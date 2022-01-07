import os
import boto3
import pandas as pd
from pathlib import Path

print('script start.')

# variables
S3_BUCKET_NAME   = 'awscli-dev-private-bucket-855' # バケット名
S3_COPY_FROM_KEY = 'athena/pure'                   # コピー元ディレクトリパス
S3_COPY_TO_KEY   = 'athena/missing_proc/'          # コピー先ディレクトリパス
FILE_NAME        = 'titanic_train.csv'             # データ加工ファイル名
ENCORDE_TYPE     = 'utf_8_sig'

# connect
connections = ["mysql_job"]

print('get read.')
copy_from_key = 's3://' + S3_BUCKET_NAME + '/' + S3_COPY_FROM_KEY + FILE_NAME
train_df = pd.read_csv(
    # copy_from_key
    's3://awscli-dev-private-bucket-855/athena/pure/titanic_train.csv'
)

print('get missing process.')
# 欠損値処理
# Embarkedの欠損値を削除、その最頻値でfreq_portを作成
freq_port = train_df["Embarked"].dropna().mode()[0]

# 欠損値を最頻値で補完
train_df["Embarked"] = train_df["Embarked"].fillna(freq_port)
train_df.isnull().sum()

# test_dfのFareの欠損値を、Fareの中央値で補完
train_df['Fare'] = train_df['Fare'].fillna(train_df['Fare'].dropna().median())
train_df.isnull().sum()

# Age列の欠損値を、Ageの中央値で補完
train_df['Age'] = train_df['Age'].fillna(train_df['Age'].dropna().median())

print('data to file upload.')
s3 = boto3.resource('s3')
copy_to_key = os.path.join(S3_COPY_TO_KEY, FILE_NAME)
s3_obj = s3.Object(S3_BUCKET_NAME, copy_to_key)
s3_obj.put(Body=train_df.to_csv(None).encode(ENCORDE_TYPE))

print('script complete.')
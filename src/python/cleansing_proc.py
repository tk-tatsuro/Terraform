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

print('get transform.')
# クレンジング処理
# 敬称を一律['Rare']に置換
train_df['Title'] = train_df['Title'].replace(['Lady', 'Countess','Capt', 'Col', 'Don', 'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer', 'Dona'], 'Rare')

# MileをMissに置換
train_df['Title'] = train_df['Title'].replace('Mlle', 'Miss')
train_df['Title'] = train_df['Title'].replace('Ms', 'Miss')
# MmeをMrsに置換
train_df['Title'] = train_df['Title'].replace('Mme', 'Mrs')


print('data to file upload.')
s3 = boto3.resource('s3')
copy_to_key = os.path.join(S3_COPY_TO_KEY, FILE_NAME)
s3_obj = s3.Object(S3_BUCKET_NAME, copy_to_key)
s3_obj.put(Body=train_df.to_csv(None).encode(ENCORDE_TYPE))

print('script complete.')
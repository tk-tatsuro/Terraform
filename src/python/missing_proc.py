import os
import boto3
import pandas as pd
from pathlib import Path

print('script start.')

# variables
S3_BUCKET_NAME   = 'terraform-development-private-bucket-102' # Bucket name
S3_COPY_FROM_KEY = 'athena/pure/'                             # Direcctry path of copy source
S3_COPY_TO_KEY   = 'athena/missing_proc/'                     # Directory path of copy destination
FILE_NAME        = 'titanic_train.csv'                        # Data processing file name
ENCORDE_TYPE     = 'utf_8_sig'

# connect
connections = ["mysql_job"]

print('get read.')
# s3_copy_from_key
copy_from_key = 's3://' + S3_BUCKET_NAME + '/' + S3_COPY_FROM_KEY + FILE_NAME
train_df = pd.read_csv(copy_from_key)

print('get missing process.')
# Missing velue process
# Removed missing values in Embarked. And create freq_port with its mode values.
freq_port = train_df["Embarked"].dropna().mode()[0]
# Complement missing values with mode values
train_df["Embarked"] = train_df["Embarked"].fillna(freq_port)
train_df.isnull().sum()
# Complement the missing value of Fare in test_df with the median Fare
train_df['Fare'] = train_df['Fare'].fillna(train_df['Fare'].dropna().median())
train_df.isnull().sum()
# Complement missing values in the Age column with the median Age
train_df['Age'] = train_df['Age'].fillna(train_df['Age'].dropna().median())

print('data to file upload.')
s3 = boto3.resource('s3')
copy_to_key = os.path.join(S3_COPY_TO_KEY, FILE_NAME)
s3_obj = s3.Object(S3_BUCKET_NAME, copy_to_key)
s3_obj.put(Body=train_df.to_csv(None).encode(ENCORDE_TYPE))

print('script complete.')
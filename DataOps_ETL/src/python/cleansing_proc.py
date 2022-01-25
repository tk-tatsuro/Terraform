import os
import boto3
import pandas as pd
from pathlib import Path

print('script start.')

# variables
S3_BUCKET_NAME   = 'terraform-development-private-bucket-102' # Bucket name
S3_COPY_FROM_KEY = 'athena/missing_proc/'                     # Direcctry path of copy source
S3_COPY_TO_KEY   = 'athena/cleansing_proc/'                   # Directory path of copy destination
FILE_NAME        = 'titanic_train.csv'                        # Data processing file name
ENCORDE_TYPE     = 'utf_8_sig'

# connect
connections = ["mysql_job"]

print('get read.')
copy_from_key = 's3://' + S3_BUCKET_NAME + '/' + S3_COPY_FROM_KEY + FILE_NAME
# s3_copy_from_key
train_df = pd.read_csv(copy_from_key)

print('start Cleansing.')
# Replaced titles with ['Rare']
train_df['Name'] = train_df['Name'].replace(['Lady', 'Countess','Capt', 'Col', 'Don', 'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer', 'Dona'], 'Rare')
# Replace Mile with Miss
train_df['Name'] = train_df['Name'].replace('Mlle', 'Miss')
train_df['Name'] = train_df['Name'].replace('Ms', 'Miss')
# Replace Mre with Mrs
train_df['Name'] = train_df['Name'].replace('Mme', 'Mrs')

print('data to file upload.')
s3 = boto3.resource('s3')
copy_to_key = os.path.join(S3_COPY_TO_KEY, FILE_NAME)
s3_obj = s3.Object(S3_BUCKET_NAME, copy_to_key)
s3_obj.put(Body=train_df.to_csv(None).encode(ENCORDE_TYPE))

print('script complete.')
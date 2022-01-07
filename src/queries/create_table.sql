-- select titanic train data
CREATE EXTERNAL TABLE IF NOT EXISTS test_dwh.titanic_train (
    `PassengerId` string,
    `Survived` string,
    `Pclass` string,
    `Name` string,
    `Sex` string,
    `Age` string,
    `SibSp` string,
    `Parch` string,
    `Ticket` string,
    `Fare` string,
    `Cabin` string,
    `Embarked` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'escapeChar'='\\',
    'quoteChar'='\"',
    'integerization.format' = ',',
    'field.delim' = ','
)
LOCATION 's3://aws-terraform-dev-private-bucket-855/athena/outlier_proc/'
TBLPROPERTIES (
    'has_encrypted_data'='false',
    'skip.header.line.count'='1',
    'serialization.encoding'='UTF-8'
)
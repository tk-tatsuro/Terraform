CREATE EXTERNAL TABLE IF NOT EXISTS testdwh_athena3.titanic_train (
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
LOCATION 's3://terraform-development-private-bucket-102/athena/cleansing_proc/'
TBLPROPERTIES (
    'has_encrypted_data'='false',
    'skip.header.line.count'='1',
    'serialization.encoding'='UTF-8'
)
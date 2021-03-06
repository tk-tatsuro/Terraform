# ----------------------------------
# IAM role
# ----------------------------------
resource "aws_iam_role" "role_glue" {
  name               = "role_glue"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "glue.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  EOF
}
resource "aws_iam_instance_profile" "instance_profile_glue" {
  name = "instance_profile_glue"
  role = aws_iam_role.role_glue.name
}
# ----------------------------------
# IAM policy
# ----------------------------------
resource "aws_iam_policy_attachment" "glue_lambda_exe" {
  name       = "AWSLambda_FullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  roles      = ["${aws_iam_role.role_glue.name}"]
}
resource "aws_iam_role_policy" "role_policy_glue" {
  name = "role_policy_glue"
  role = aws_iam_role.role_glue.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "glue:*",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:GetBucketAcl",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeRouteTables",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::aws-glue-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-glue-*/*",
                "arn:aws:s3:::*/*aws-glue-*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::crawler-public*",
                "arn:aws:s3:::aws-glue-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateExportTask",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateExportTask",
                "logs:DescribeLogGroups"
            ],
            "Resource": [
                "arn:aws:logs:*:*:/aws-glue/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Condition": {
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "aws-glue-service-resource"
                    ]
                }
            },
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
  EOF
}


# ----------------------------------
# Data catalog create
# ----------------------------------
resource "aws_glue_catalog_database" "database_glue_test" {
  name = "database_glue_test"
}
# ----------------------------------
# Data catalog database for athena
# ----------------------------------
resource "aws_glue_catalog_database" "glue_catalog_database_name" {
  name = var.glue_catalog_database_name
}
# ----------------------------------
# Data catalog table for athena
# ----------------------------------
resource "aws_glue_catalog_table" "titanic_train" {
  database_name = aws_glue_catalog_database.glue_catalog_database_name.name
  name          = var.glue_catalog_table_name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${var.glue_job_bucket}/athena/cleansing_proc/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }
    columns {
      name = "PassengerId"
      type = "string"
    }
    columns {
      name = "Survived"
      type = "string"
    }
    columns {
      name = "Pclass"
      type = "string"
    }
    columns {
      name = "Name"
      type = "string"
    }
    columns {
      name = "Sex"
      type = "string"
    }
    columns {
      name = "Age"
      type = "string"
    }
    columns {
      name = "SibSp"
      type = "string"
    }
    columns {
      name = "Parch"
      type = "string"
    }
    columns {
      name = "Ticket"
      type = "string"
    }
    columns {
      name = "Fare"
      type = "string"
    }
    columns {
      name = "Cabin"
      type = "string"
    }
    columns {
      name = "Embarked"
      type = "string"
    }
  }
  partition_keys {
    name = "orderdate"
    type = "string"
  }
}



# ----------------------------------
# ETL job missing value process
# ----------------------------------
resource "aws_glue_job" "glue_job_test_missing" {
  name     = "glue_job_test_missing"
  role_arn = aws_iam_role.role_glue.arn


  command {
    script_location = "s3://${var.s3_bucket_2}/python_shell/missing_proc.py"
    python_version  = 3
  }
  glue_version      = "2.0"
  number_of_workers = 10
  worker_type       = "G.1X"
  # Execute arg
  # default_arguments = {
  #   "--"     = var.
  # }
}
# ----------------------------------
# ETL job cleansing value process
# ----------------------------------
resource "aws_glue_job" "glue_job_test_cleansing" {
  name     = "glue_job_test_cleansing"
  role_arn = aws_iam_role.role_glue.arn

  command {
    script_location = "s3://${var.s3_bucket_2}/python_shell/cleansing_proc.py"
    python_version  = 3
  }
  glue_version      = "2.0"
  number_of_workers = 10
  worker_type       = "G.1X"
  # Execute arg
  # default_arguments = {
  #   "--"     = var.
  # }
}


# ----------------------------------
# ETL job workflow
# ----------------------------------
resource "aws_glue_workflow" "glue_job_test_workflow" {
  name = "glue_job_test_workflow"
}

resource "aws_glue_trigger" "trigger" {
  name     = "glue_job_test_workflow_start"
  schedule = "cron(0/60000 * * * ? *)"
  type     = "SCHEDULED"
  workflow_name = aws_glue_workflow.glue_job_test_workflow.name
  actions {
    job_name = aws_glue_job.glue_job_test_missing.name
  }
  actions {
    job_name = aws_glue_job.glue_job_test_cleansing.name
  }
}


## change from RDS to S3
# ----------------------------------
# Connection to RDS
# ----------------------------------
# resource "aws_glue_connection" "rds_connection_glue_test" {
#   connection_properties = {
#     JDBC_CONNECTION_URL = "jdbc:postgresql://${aws_db_instance.rds_glue_test.endpoint}/testdb"
#     PASSWORD            = var.connect_rds_password
#     USERNAME            = var.connect_rds_username
#   }
#   name = "rds_connection_glue_test"
#   physical_connection_requirements {
#     availability_zone      = aws_subnet.subnet1_glue_test.availability_zone
#     security_group_id_list = [aws_security_group.securty_group_glue_test.id]
#     subnet_id              = aws_subnet.subnet1_glue_test.id
#   }
# }
# ----------------------------------
# Crawler
# ----------------------------------
# resource "aws_glue_crawler" "crawler_glue_test" {
#   database_name = aws_glue_catalog_database.database_glue_test.name
#   name          = "database_glue_test"
#   role          = aws_iam_role.role_glue.arn

#   jdbc_target {
#     connection_name = aws_glue_connection.rds_connection_glue_test.name
#     path            = "testdb/%"
#   }
# }

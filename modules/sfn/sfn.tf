# ----------------------------------
# S3 private bucket for Lambda logs
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket6" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-858"
  acl    = "private"
  # Manege version of S3 source
  versioning {
    enabled = false
  }
  # Encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  # Delete rule
  lifecycle {
    prevent_destroy = false
  }
}
# Create directry
resource "aws_s3_bucket_object" "s3-private-bucket6-object" {
  key    = "lambda_logs/"
  bucket = aws_s3_bucket.s3-private-bucket6.id
  force_destroy = true
}
# Access block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket6" {
  bucket                  = aws_s3_bucket.s3-private-bucket6.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
data "aws_iam_policy_document" "s3" {
  statement {
    sid     = "SFNAssumeRolePolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.${var.region}.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "s3" {
  name               = "${var.enviroment}-s3-role"
  assume_role_policy = "${data.aws_iam_policy_document.s3.json}"
}
resource "aws_iam_role_policy" "role_policy_s3" {
  name = "role_policy_s3"
  role = aws_iam_role.s3.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetBucketAcl",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "*"
        }
    ]
}
  EOF
}


# ----------------------------------
# Step Functions policy
# ----------------------------------
data "aws_iam_policy_document" "sfn" {
  statement {
    sid     = "SFNAssumeRolePolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.${var.region}.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "sfn" {
  name               = "${var.enviroment}-sfn-role"
  assume_role_policy = "${data.aws_iam_policy_document.sfn.json}"
}
# Attach policy
resource "aws_iam_policy_attachment" "sfn" {
  name       = "AWSLambdaBasicExecutionRole"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = ["${aws_iam_role.sfn.name}"]
}
resource "aws_iam_policy_attachment" "sfn_lambda_exe" {
  name       = "AWSLambda_FullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  roles      = ["${aws_iam_role.sfn.name}"]
}
resource "aws_iam_policy_attachment" "log_group" {
  name       = "CloudWatchFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  roles      = ["${aws_iam_role.sfn.name}"]
}
resource "aws_iam_role_policy" "role_policy_sfn" {
  name = "role_policy_sfn"
  role = aws_iam_role.sfn.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl",
                "s3:Get*",
                "s3:Put*",
                "s3:List*"
            ],
            "Resource": "${var.log_export_bucket_arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateExportTask",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateExportTask",
                "logs:DescribeLogGroups",
                "logs:Get*"
            ],
            "Resource": "${var.lambda_log_group_arn}"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "${var.log_export_bucket_arn}"
        }
    ]
}
  EOF
}


# ----------------------------------
# Lambda policy
# ----------------------------------
data "aws_iam_policy_document" "lambda" {
  statement {
    sid     = "LambdaAssumeRolePolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "logs.${var.region}.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}
resource "aws_iam_role" "lambda" {
  name               = "${var.enviroment}-lambda-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda.json}"
}
# Attach policy
resource "aws_iam_policy_attachment" "lambda" {
  name       = "LambdaBasicExecRole"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = ["${aws_iam_role.lambda.name}"]
}
resource "aws_iam_policy_attachment" "lambda_exe" {
  name       = "AWSLambda_FullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  roles      = ["${aws_iam_role.lambda.name}"]
}
resource "aws_iam_policy_attachment" "s3" {
  name       = "AmazonS3FullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  roles      = ["${aws_iam_role.lambda.name}"]
}
resource "aws_iam_role_policy" "role_policy_lambda" {
  name = "role_policy_lambda"
  role = aws_iam_role.lambda.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:Put*",
                "s3:List*"
            ],
            "Resource": "${var.log_export_bucket_arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateExportTask",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateExportTask",
                "logs:DescribeLogGroups",
                "logs:Get*"
            ],
            "Resource": "${var.lambda_log_group_arn}"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "glue:*",
            "Resource": "*"
        }
    ]
}
  EOF
}


# ----------------------------------
# Lambda function
# ----------------------------------
# Generate an empty Lambda file
data "archive_file" "initial_lambda_package" {
  type        = "zip"
  output_path = "./src/.temp_files/lambda.zip"
  source {
    content  = "# empty"
    filename = "main.py"
  }
}

# Upload Lambda files to S3
resource "aws_s3_bucket_object" "lambda_file" {
  bucket = "${aws_s3_bucket.s3-private-bucket6.id}"
  key    = "initial.zip"
  source = "./src/.temp_files/lambda.zip"
}

# Generate a Lambda function
# Refer to the Lambda file placed on S3
resource "aws_lambda_function" "lambda_test" {
  function_name     = "lambda_test"
  role             = "${aws_iam_role.lambda.arn}"
  handler           = "main.handler"
  runtime           = "python3.8"
  timeout           = 60
  publish           = true
  s3_bucket         = "${aws_s3_bucket.s3-private-bucket6.id}"
  s3_key            = "${aws_s3_bucket_object.lambda_file.id}"
}


# ----------------------------------
# Stete machine
# ----------------------------------
resource "aws_sfn_state_machine" "sfn" {
  name     = "${var.enviroment}-sfn"
  role_arn = "${aws_iam_role.sfn.arn}"
  definition = <<EOT
  {
    "Comment": "Export Cloudwatch LogStream recursively",
    "StartAt": "Export logs to S3",
    "TimeoutSeconds": 60,
    "States": {
      "Export logs to S3": {
        "Type": "Task",
        "Resource": "${var.lambda_test_arn}",
        "Next": "Finished process ?"
      },
      "Finished process ?": {
        "Type": "Choice",
        "Choices": [
          {
            "Variable": "$.status",
            "StringEquals": "running",
            "Next": "Wait and refuse"
          },
          {
            "Variable": "$.status",
            "StringEquals": "completed",
            "Next": "Success"
          }
        ]
      },
      "Wait and refuse": {
        "Type": "Wait",
        "Seconds": 5,
        "Next": "Export logs to S3"
      },
      "Success": {
        "Type": "Succeed"
      }
    }
  }
EOT
  logging_configuration {
    log_destination = "${var.sfn_arn}"
    include_execution_data = true
    level                  = "ALL"
  }
}
# ----------------------------------
# Cloud Watch Logs (Log Group)
# ----------------------------------
resource "aws_cloudwatch_log_group" "log_group_for_sfn" {
  name = "log-group-for-sfn"
  retention_in_days = 0
}


# ----------------------------------
# Eventbridge (Cloud Watch Events)
# ----------------------------------
resource "aws_cloudwatch_event_rule" "cloudwatch_lambda_test_rule" {
    name                = "cloudwatch-lambda-test-rule"
    schedule_expression = "cron(0/5 * * * ? *)"
}
resource "aws_cloudwatch_event_target" "cloudwatch_lambda_test_target" {
    rule      = "${aws_cloudwatch_event_rule.cloudwatch_lambda_test_rule.name}"
    target_id = "lambda_test"
    arn       = "${aws_lambda_function.lambda_test.arn}"
}
resource "aws_lambda_permission" "cloudwatch_lambda_test_permission" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda_test.function_name}"
    principal     = "events.amazonaws.com"
    source_arn    = "${aws_cloudwatch_event_rule.cloudwatch_lambda_test_rule.arn}"
}


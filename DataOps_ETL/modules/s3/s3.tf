## S3 description
# private-bucket-101 : S3 private bucket 2 for source
# private-bucket-102 : S3 private bucket 3 for data
# private-bucket-102 : S3 private bucket 4 for Terraform log
# private-bucket-103 : S3 private bucket 5 for Query log
# private-bucket-104 : S3 private bucket 6 for Lambda log

# ----------------------------------
# S3 private bucket2 for source
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket2" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-101"
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
resource "aws_s3_bucket_object" "s3-private-bucket2-object-sh" {
  key    = "python_shell/"
  bucket = aws_s3_bucket.s3-private-bucket2.id
  force_destroy = true
}
resource "aws_s3_bucket_object" "s3-private-bucket2-object" {
  bucket = aws_s3_bucket.s3-private-bucket2.id
  for_each= fileset("./src/pyshon_shell/", "*")
  key    = "pyshon_shell/${each.value}"
  force_destroy = true
}
# Access block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket2" {
  bucket                  = aws_s3_bucket.s3-private-bucket2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ----------------------------------
# S3 private bucket3 for data
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket3" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-102"
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
resource "aws_s3_bucket_object" "s3-private-bucket3-object1" {
  key    = "athena/tmp/"
  bucket = aws_s3_bucket.s3-private-bucket3.id
  force_destroy = true
}
resource "aws_s3_bucket_object" "s3-private-bucket3-object2" {
  key    = "athena/pure/"
  bucket = aws_s3_bucket.s3-private-bucket3.id
  force_destroy = true
}
resource "aws_s3_bucket_object" "s3-private-bucket3-object3" {
  key    = "athena/missing_proc/"
  bucket = aws_s3_bucket.s3-private-bucket3.id
  force_destroy = true
}
resource "aws_s3_bucket_object" "s3-private-bucket3-object4" {
  key    = "athena/cleansing_proc/"
  bucket = aws_s3_bucket.s3-private-bucket3.id
  force_destroy = true
}
resource "aws_s3_bucket_object" "s3-private-bucket3-object5" {
  key    = "athena_result/cleansing_proc/"
  bucket = aws_s3_bucket.s3-private-bucket3.id
  force_destroy = true
}
# Access block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket3" {
  bucket                  = aws_s3_bucket.s3-private-bucket3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# ----------------------------------
# S3 private bucket4 for terraform log
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket4" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-103"
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
resource "aws_s3_bucket_object" "s3-private-bucket4-object" {
  key    = "terraform_logs/"
  bucket = aws_s3_bucket.s3-private-bucket4.id
  force_destroy = true
}
# Access block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket4" {
  bucket                  = aws_s3_bucket.s3-private-bucket4.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# ----------------------------------
# S3 private bucket5 for query log
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket5" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-104"
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
resource "aws_s3_bucket_object" "s3-private-bucket5-object" {
  key    = "query_logs/"
  bucket = aws_s3_bucket.s3-private-bucket5.id
  force_destroy = true
}
# Access block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket5" {
  bucket                  = aws_s3_bucket.s3-private-bucket5.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# ----------------------------------
# S3 private bucket for Lambda logs
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket06" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-105"
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
resource "aws_s3_bucket_object" "s3-private-bucket06-object" {
  key    = "lambda_logs/"
  bucket = aws_s3_bucket.s3-private-bucket06.id
  force_destroy = true
}
# Access block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket06" {
  bucket                  = aws_s3_bucket.s3-private-bucket06.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
data "aws_iam_policy_document" "s3_bucket" {
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
resource "aws_iam_role" "s3_bucket" {
  name               = "${var.enviroment}-s3-bucket-role"
  assume_role_policy = "${data.aws_iam_policy_document.s3_bucket.json}"
}
resource "aws_iam_role_policy" "role_policy_s3_bucket" {
  name = "role_policy_s3_bucket"
  role = aws_iam_role.s3_bucket.id
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
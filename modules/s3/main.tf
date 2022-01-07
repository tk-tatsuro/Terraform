# ----------------------------------
# S3 description
# ----------------------------------
# private-bucket-854 : S3 private bucket2 for source
# private-bucket-855 : S3 private bucket3 for data
# private-bucket-857 : S3 private bucket3 for query log


# ----------------------------------
# S3 private bucket2 for source
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket2" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-854"
  acl    = "private"

  # バージョン管理
  versioning {
    enabled = false
  }

  # 暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

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
  bucket = "${var.project}-${var.enviroment}-private-bucket-855"
  acl    = "private"

  # バージョン管理
  versioning {
    enabled = false
  }

  # 暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
# access_block
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
  bucket = "${var.project}-${var.enviroment}-private-bucket-856"
  acl    = "private"

  # バージョン管理
  versioning {
    enabled = false
  }

  # 暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
# access_block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket4" {
  bucket                  = aws_s3_bucket.s3-private-bucket4.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# ----------------------------------
# S3 private bucket3 for query log
# ----------------------------------
resource "aws_s3_bucket" "s3-private-bucket5" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-857"
  acl    = "private"

  # バージョン管理
  versioning {
    enabled = false
  }

  # 暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
# access_block
resource "aws_s3_bucket_public_access_block" "s3-private-bucket5" {
  bucket                  = aws_s3_bucket.s3-private-bucket5.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

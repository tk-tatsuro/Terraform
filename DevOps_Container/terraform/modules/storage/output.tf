# ----------------------------------
# storage output
# ----------------------------------
output "aws_s3_bucket_cntn" {
    value = aws_s3_bucket.alb_log.id
    sensitive = true
}

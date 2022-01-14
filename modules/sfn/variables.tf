# ----------------------------------
# Variables
# ----------------------------------
variable "region" {
  type = string
}
variable "enviroment" {
  type = string
}
variable "project" {
  type = string
}
variable "lambda_test_arn" {
}
variable "lambda_log_group_arn" {
}
variable "log_export_bucket_arn" {
}
variable "sfn_arn" {
}
variable "s3_private_bucket06" {
}
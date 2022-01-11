# ----------------------------------
# variable
# ----------------------------------
variable "athena_database_name" {
  type        = string
}
variable "athena_table_name" {
  type        = string
}
variable "athena_result_bucket_name" {
  type        = string
  description = "S3 bucket name for Athena result logs"
}
variable "log_bucket_name" {
  type = string
}
variable "athena_log_bucket_name" {
  type = string
}
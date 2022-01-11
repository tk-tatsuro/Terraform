# ----------------------------------
# Variables
# ----------------------------------
variable "s3_bucket_2" {
  type = string
}
variable "s3_bucket2_path" {
  type = string
}
variable "glue_job_python_bucket" {
}
variable "glue_catalog_database_name" {
}
variable "glue_catalog_table_name" {
}
variable "connect_athena_password" {
  type = string
}
variable "connect_athena_username" {
  type = string
}
variable "athena_result_bucket_name" {
}

## Change from RDS to S3
# variable "connect_rds_password" {
#   type = string
# }
# variable "connect_rds_username" {
#   type = string
# }
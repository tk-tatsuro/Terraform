# ----------------------------------
# Variables
# ----------------------------------
variable "connect_rds_password" {
  type = string
}
variable "connect_rds_username" {
  type = string
}
variable "connect_athena_password" {
  type = string
}
variable "connect_athena_username" {
  type = string
}
variable "s3_bucket_2" {
  type = string
}
variable "s3_bucket2_path" {
  type = string
}
variable "glue_catalog_database_name" {
  description = "データベース名"
}
variable "glue_catalog_table_name" {
  description = "テーブル名"
}
# variable "glue_job_role_arn" {
# }
variable "athena_result_bucket_name" {
}
variable "glue_job_python_bucket" {
}
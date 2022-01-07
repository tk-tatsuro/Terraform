# ----------------------------------
# Variables common
# ----------------------------------
variable "project" {
  type = string
}
variable "enviroment" {
  type = string
}
variable "region" {
  type = string
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}


# ----------------------------------
# Variables Athena
# ----------------------------------
variable "s3_bucket_2" {
  type = string
}
variable "s3_bucket2_path" {
  type = string
}
variable "athena_result_bucket_name" {
  type = string
}
variable "athena_log_bucket_name" {
  type = string
}


# ----------------------------------
# Variables Glue
# ----------------------------------
variable "connect_athena_password" {
  type = string
}
variable "connect_athena_username" {
  type = string
}
variable "connect_rds_password" {
  type = string
}
variable "connect_rds_username" {
  type = string
}


variable "glue_catalog_database_name" {
  type = string
}
variable "glue_catalog_table_name" {
  type = string
}
variable "athena_database_name" {
  type = string
}
variable "athena_table_name" {
  type = string
}
variable "log_bucket_name" {
  type = string
}
# variable "glue_job_role_arn" {
# }
variable "glue_job_python_bucket" {
}
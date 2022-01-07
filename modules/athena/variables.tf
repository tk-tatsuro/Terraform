# ----------------------------------
# variable
# ----------------------------------
variable "athena_database_name" {
  type        = string
  description = "データベース名"
}
variable "athena_table_name" {
  type        = string
  description = "テーブル名"
}
variable "athena_result_bucket_name" {
  type        = string
  description = "Athenaの結果を出力するためのS3バケット名"
}
variable "log_bucket_name" {
  type = string
}
variable "athena_log_bucket_name" {
  type = string
}
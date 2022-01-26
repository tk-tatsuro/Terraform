# ----------------------------------
# database variables
# ----------------------------------
variable "rds_password" {
  type = string
}
variable "rds_username" {
  type = string
}
variable "rds_db_name" {
  type = string
}
variable "aws_private_subnet_a" {
}
variable "aws_private_subnet_b" {
}
variable "security_group_db" {
}
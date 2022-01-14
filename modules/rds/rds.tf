## Change from RDS to S3
# # ----------------------------------
# # Subnet group
# # ----------------------------------
# resource "aws_db_subnet_group" "rds_subnet_glue_test" {
#   name = "rds_subnet_glue_test"
#   subnet_ids = ["${aws_subnet.subnet1_glue_test.id}",
#   "${aws_subnet.subnet2_glue_test.id}"]
#   tags = {
#     Name = "subnet_glue_test"
#   }
# }

# # ----------------------------------
# # Database instance
# # ----------------------------------
# resource "aws_db_instance" "rds_glue_test" {
#   identifier             = "rds-glue-test"
#   allocated_storage      = 20
#   storage_type           = "gp2"
#   engine                 = "postgres"
#   engine_version         = "11.12"
#   instance_class         = "db.t3.micro"
#   name                   = "${var.rds_db_name}"
#   username               = "${var.rds_username}"
#   password               = "${var.rds_password}"
#   vpc_security_group_ids = ["${aws_security_group.securty_group_glue_test.id}"]
#   db_subnet_group_name   = aws_db_subnet_group.rds_subnet_glue_test.id
#   skip_final_snapshot    = true
# }

# # ----------------------------------
# # Variables
# # ----------------------------------
# variable "rds_password" {
#   type = string
# }
# variable "rds_username" {
#   type = string
# }
# variable "rds_db_name" {
#   type = string
# }

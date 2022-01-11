## Change from Redshift to Athena
# ----------------------------------
# Redshift
# ----------------------------------
# resource "aws_redshift_subnet_group" "redshift_subnet_glue_test" {
#   name = "redshift-subnet-glue-test"
#   subnet_ids = ["${aws_subnet.subnet1_glue_test.id}",
#   "${aws_subnet.subnet2_glue_test.id}"]
#   tags = {
#     environment = "subnet_glue_test"
#   }
# }



# resource "aws_redshift_cluster" "redshift_glue_test" {
#   cluster_identifier        = "redshift-glue-test"
#   database_name             = "testdwh"
#   master_username           = "testuser"
#   master_password           = "Test2020"
#   node_type                 = "ra3.xlplus"
#   cluster_type              = "single-node"
#   publicly_accessible       = false
#   skip_final_snapshot       = true
#   cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_glue_test.name
#   vpc_security_group_ids    = ["${aws_security_group.securty_group_glue_test.id}"]
# }




# # ----------------------------------
# # Connection to Redshift in glue.tf
# # ----------------------------------
# resource "aws_glue_connection" "redshift_connection_glue_test" {
#   connection_properties = {
#     JDBC_CONNECTION_URL = "jdbc:postgresql://${aws_redshift_cluster.redshift_glue_test.endpoint}/testdwh"
#     PASSWORD            = var.connect_redshift_password
#     USERNAME            = var.connect_redshift_username
#   }
#   name = "redshift_connection_glue_test"
#   physical_connection_requirements {
#     availability_zone      = aws_subnet.subnet1_glue_test.availability_zone
#     security_group_id_list = [aws_security_group.securty_group_glue_test.id]
#     subnet_id              = aws_subnet.subnet1_glue_test.id
#   }
# }


# # ----------------------------------
# # Variables
# # ----------------------------------
# variable "connect_redshift_password" {
#   type = string
# }
# variable "connect_redshift_username" {
#   type = string
# }

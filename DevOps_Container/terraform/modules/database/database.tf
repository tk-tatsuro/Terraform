# ----------------------------------
# Subnet group
# ----------------------------------
resource "aws_db_subnet_group" "private_subnet_group_db" {
  name = "private_subnet_db"
  subnet_ids = [
    "${var.aws_private_subnet_a}",
    "${var.aws_private_subnet_b}"
  ]
  tags = {
    Name = "private_subnet_group_db"
  }
}

# ----------------------------------
# Database instance
# ----------------------------------
## source DB
resource "aws_db_instance" "db_rds_source" {
  identifier             = "db-rds-source"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  name                   = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [
    "${var.security_group_db}"
  ]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group_db.id
  skip_final_snapshot    = true
  enabled_cloudwatch_logs_exports     = [
    "error",
    "general",
    "slowquery"
  ]
  parameter_group_name = aws_db_parameter_group.main.name
  option_group_name    = aws_db_option_group.main.name
  monitoring role
  monitoring_role_arn   = aws_iam_role.rds_monitoring_role.arn
  monitoring_interval   = 60
  DB storage encryption
  kms_key_id        = aws_kms_key.rds_storage.arn
}
## replica DB
resource "aws_db_instance" "db_rds_replica" {
  identifier             = "db-rds-replica"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  name                   = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [
    "${var.security_group_db}"
  ]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group_db.id
  skip_final_snapshot    = true
  replicate_source_db  = aws_db_instance.db_rds_source.identifier
  # save days
  backup_retention_period     = 5
}
# DB params
resource "aws_db_parameter_group" "main" {
  name   = "main"
  # family setting as DB params
  family = "mysql8.0"
  # set up slow query logs
  parameter {
    name = "slow_query_log"
    value = 1
  }
  # set up general query logs
  parameter {
    name = "general_log"
    value = 1
  }
  # second to judge as slow query
  parameter {
    name = "long_query_time"
    value = 5
  }
}
# default settings largely empty
resource "aws_db_option_group" "main" {
  name = "main"
  engine_name = "mysql"
  major_engine_version = "8.0"
}


# ----------------------------------
# DB IAM role
# ----------------------------------
data "aws_iam_policy_document" "rds_monitoring_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "rds_monitoring_role" {
  name               = "rds_monitoring_role"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_policy.json
}

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds_monitoring_role.name
}


# ----------------------------------
# DB storage encryption & decryption
# ----------------------------------
resource "aws_kms_key" "rds_storage" {
  description             = "key to encrypt rds storage."
  key_usage               = "ENCRYPT_DECRYPT"
  # key delete days
  deletion_window_in_days = 7
  # rotaion of master key
  enable_key_rotation     = true
}
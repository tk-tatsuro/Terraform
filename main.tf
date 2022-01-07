# ----------------------------------
# Terraform versions
# ----------------------------------
terraform {
  required_version = ">=1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-bucket-tk-tatsuro"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# ----------------------------------
# Provider
# ----------------------------------
provider "aws" {
  profile    = "terraform"
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


# ----------------------------------
# S3
# ----------------------------------
module "S3" {
  source     = "./modules/s3"
  project    = var.project
  enviroment = var.enviroment
}


# ----------------------------------
# Glue
# ----------------------------------
module "glue" {
  source                     = "./modules/glue"
  glue_catalog_database_name = var.glue_catalog_database_name
  glue_catalog_table_name    = var.glue_catalog_table_name
  athena_result_bucket_name  = var.athena_result_bucket_name
  connect_athena_password = var.connect_athena_password
  connect_athena_username = var.connect_athena_username
  s3_bucket_2             = var.s3_bucket_2
  s3_bucket2_path         = var.s3_bucket2_path
  connect_rds_password    = var.connect_rds_password
  connect_rds_username    = var.connect_rds_username
  glue_job_python_bucket  = var.glue_job_python_bucket
}


# ----------------------------------
# Athena
# ----------------------------------
module "athena" {
  source                    = "./modules/athena"
  athena_database_name      = var.athena_database_name
  athena_table_name         = var.athena_table_name
  log_bucket_name           = var.log_bucket_name
  athena_result_bucket_name = var.athena_result_bucket_name
  athena_log_bucket_name    = var.athena_log_bucket_name
}

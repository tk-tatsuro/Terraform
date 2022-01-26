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
    profile = "archetype"
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
# Execute the instance module
# ----------------------------------
module "instance" {
  source       = "./modules/instance"
  aws_vpc_cntn = module.instance.aws_vpc_cntn
}

# ----------------------------------
# Execute the network module
# ----------------------------------
module "network" {
  source              = "./modules/network"
  aws_vpc_cntn        = module.instance.aws_vpc_cntn
  aws_public_subnet_a = module.instance.aws_public_subnet_a
  aws_public_subnet_b = module.instance.aws_public_subnet_b
  aws_s3_bucket_cntn  = module.storage.aws_s3_bucket_cntn
}

# ----------------------------------
# Execute the container module
# ----------------------------------
module "container" {
  source              = "./modules/container"
  alb_target_group    = module.network.alb_target_group
  security_group_api  = module.network.security_group_api
  security_group_alb  = module.network.security_group_alb
  aws_public_subnet_a = module.instance.aws_public_subnet_a
  aws_public_subnet_b = module.instance.aws_public_subnet_b
  aws_vpc_cntn        = module.instance.aws_vpc_cntn
}
# ----------------------------------
# Execute the storage module
# ----------------------------------
module "storage" {
  source     = "./modules/storage"
  project    = var.project
  region     = var.region
  enviroment = var.enviroment
}

# ----------------------------------
# Execute the database module
# ----------------------------------
module "database" {
  source               = "./modules/database"
  rds_db_name          = var.rds_db_name
  rds_username         = var.rds_username
  rds_password         = var.rds_password
  aws_private_subnet_a = module.instance.aws_private_subnet_a
  aws_private_subnet_b = module.instance.aws_private_subnet_b
  security_group_db    = module.network.security_group_db
}
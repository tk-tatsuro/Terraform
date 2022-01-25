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
  source             = "./modules/network"
  aws_vpc_cntn       = module.instance.aws_vpc_cntn
  aws_subnet_a       = module.instance.aws_subnet_a
  aws_subnet_b       = module.instance.aws_subnet_b
  aws_s3_bucket_cntn = module.storage.aws_s3_bucket_cntn
}

# ----------------------------------
# Execute the container module
# ----------------------------------
module "container" {
  source             = "./modules/container"
  alb_target_group   = module.network.alb_target_group
  alb_security_group_api = module.network.alb_security_group_api
  alb_security_group_alb = module.network.alb_security_group_alb
  aws_subnet_a       = module.instance.aws_subnet_a
  aws_subnet_b       = module.instance.aws_subnet_b
  aws_vpc_cntn = module.instance.aws_vpc_cntn
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
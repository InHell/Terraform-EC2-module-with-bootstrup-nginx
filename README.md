# EC2-module-with-bootstrup-nginx
AWS terraform example of EC2 instance with bash bootstrup of nginx + some APP build/launch of JS*

important.
A- needs main module where this module is included (like this example of MAIN.TF)
--------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}
provider "aws" {
  region = var.region
}

# remote state if needed 
terraform {
  backend "s3" {
    bucket = "remotestate S3 bucket id"
    key    = "location-folder/terraform.tfstate"
    region = "some AWS region"
  }
}


#--- main modules sector---

(if need set a ENV. like dev stage prod...etc)
locals {
  multienv = var.environment
}

# (declare using module)
module "my_EC2_machine" {
  source      = "./modules/ec2_standalone"
  # (sent env to module)
  environment = local.multienv
}

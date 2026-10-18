terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # After creating the state backend once, uncomment to store state remotely:
  # backend "s3" {
  #   bucket         = "<your-state-bucket>"
  #   key            = "examples/basic/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  tags = {
    Project   = "terraform-aws-baseline"
    ManagedBy = "terraform"
  }
}

module "state_backend" {
  source = "../../modules/state-backend"

  bucket_name = "replace-with-a-globally-unique-name"
  tags        = local.tags
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = "demo"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_nat_gateway   = false
  tags                 = local.tags
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "state_bucket" {
  value = module.state_backend.bucket_name
}

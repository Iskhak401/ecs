terraform {
  backend "s3" {
    bucket = "peer-terraform-state-dev"
    key    = "global/state/peer-api"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  
  region = var.aws_region
  default_tags {
    tags = {
      Owner = var.owner
      Environment = var.environment
      Project = var.project
      Terraform = true
    }
  }
}

provider "aws" {
  alias   = "cloudfront-global"
  region  = "us-east-1" // NOTE: This needs to be us-east-1 for WAFv2 on scope CLOUDFRONT
}

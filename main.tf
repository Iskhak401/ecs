terraform {
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
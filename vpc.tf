################################################################################
# setup vpc
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  enable_dns_support = true
  enable_dns_hostnames = true
  enable_nat_gateway = true
  single_nat_gateway  = false
  one_nat_gateway_per_az = true

  azs = ["${local.region}a", "${local.region}b"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.2.0/24", "10.0.3.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  database_subnets = ["10.0.4.0/24", "10.0.5.0/24"]
  elasticache_subnets = ["10.0.6.0/24", "10.0.7.0/24"] 
}
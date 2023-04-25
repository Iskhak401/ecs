# AWS Virtual Private Network (VPC) Module

This Terraform module creates an AWS Virtual Private Cloud (VPC) with public and private subnets across multiple availability zones, as well as an internet gateway, NAT gateways, and route tables.

## Usage

Example usage:

module "my_vpc" {
  source = "path/to/module"

  name_prefix = "my-vpc"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets_cidrs_per_availability_zone = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidrs_per_availability_zone = ["10.0.3.0/24", "10.0.4.0/24"]
  single_nat = false
}

Inputs
name_prefix - (Required) Prefix for naming resources.
vpc_cidr - (Required) CIDR block for VPC.
availability_zones - (Required) List of availability zones to use for subnets.
public_subnets_cidrs_per_availability_zone - (Required) List of CIDR blocks for public subnets, one per availability zone.
private_subnets_cidrs_per_availability_zone - (Required) List of CIDR blocks for private subnets, one per availability zone.
single_nat - (Optional) Whether to use a single NAT gateway for all private subnets (defaults to false).
Outputs
vpc_id - ID of the VPC.
public_subnet_ids - IDs of the public subnets.
private_subnet_ids - IDs of the private subnets.
nat_gateway_ids - IDs of the NAT gateways (if any).
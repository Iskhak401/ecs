################################################################################
# setup vpc
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${local.name}-vpc"
  cidr = var.vpc_cidr_block

  enable_dns_support = true
  enable_dns_hostnames = true
  enable_nat_gateway = true
  single_nat_gateway  = false
  one_nat_gateway_per_az = true

  azs = ["${local.region}a", "${local.region}b"]
  public_subnets = [var.vpc_subnet_cidr_blocks[0], var.vpc_subnet_cidr_blocks[1]]
  private_subnets = [var.vpc_subnet_cidr_blocks[2], var.vpc_subnet_cidr_blocks[3]]
  database_subnets = [var.vpc_subnet_cidr_blocks[4], var.vpc_subnet_cidr_blocks[5]]
  elasticache_subnets = [var.vpc_subnet_cidr_blocks[6], var.vpc_subnet_cidr_blocks[7]] 

  database_dedicated_network_acl = true
  #default inbound will deny any connection that does not match one of previous rules
  database_inbound_acl_rules = concat(local.vpc_acl_default_block_all, 
                                      [ { "cidr_block": var.vpc_cidr_block, 
                                          "from_port": var.port_number,
                                          "to_port": var.port_number, 
                                          "protocol": "tcp", 
                                          "rule_action": "allow", 
                                          "rule_number": 10 } ]
                                    )

  database_outbound_acl_rules = concat(local.vpc_acl_default_outbound_service, local.vpc_acl_default_block_all)

  elasticache_dedicated_network_acl = true
  elasticache_inbound_acl_rules = concat(local.vpc_acl_default_block_all, 
                                      [ { "cidr_block": var.vpc_cidr_block, 
                                          "from_port": var.redis_port,
                                          "to_port": var.redis_port, 
                                          "protocol": "tcp", 
                                          "rule_action": "allow", 
                                          "rule_number": 10 } ]
                                    )

  elasticache_outbound_acl_rules = concat(local.vpc_acl_default_outbound_service, local.vpc_acl_default_block_all)

  public_dedicated_network_acl = true

  public_inbound_acl_rules =  [ { "cidr_block": local.anywhere_ip, 
                                  "from_port": 80,
                                  "to_port": 80, 
                                  "protocol": "tcp", 
                                  "rule_action": "allow", 
                                  "rule_number": 10 },
                                { "cidr_block": local.anywhere_ip, 
                                  "from_port": 443,
                                  "to_port": 443, 
                                  "protocol": "tcp", 
                                  "rule_action": "allow", 
                                  "rule_number": 20 },
                                { "cidr_block": local.anywhere_ip, 
                                  "from_port": 22,
                                  "to_port": 22, 
                                  "protocol": "tcp", 
                                  "rule_action": "allow", 
                                  "rule_number": 30 },
                                { "cidr_block": local.anywhere_ip, 
                                  "from_port": 1025,
                                  "to_port": 65535, 
                                  "protocol": "tcp", 
                                  "rule_action": "allow", 
                                  "rule_number": 40 } ]
                                      

}

################################################################################
# setup vpc private subnet acl
################################################################################

resource "aws_network_acl" "acl_subnet_fargate" {
  vpc_id = module.vpc.vpc_id

  subnet_ids = [ module.vpc.private_subnets[0] , module.vpc.private_subnets[1] ]

  egress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = local.anywhere_ip
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = local.anywhere_ip
    from_port  = 1025
    to_port    = 65535
  }

  ingress {
    protocol   = "all"
    rule_no    = 20000
    action     = "deny"
    cidr_block = local.anywhere_ip
    from_port  = 0
    to_port    = 0
  }
}

################################################################################
# setup vpc endpoints
################################################################################


data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}



module "vpc_endpoint" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [data.aws_security_group.default.id]

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "${local.name}-s3-vpc-endpoint" }
    }
  }
}


####################################
###### Enabling vpc FLow logs ######
####################################

resource "aws_flow_log" "peer-vpc" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs.arn
  log_destination = aws_cloudwatch_log_group.peer-vpc.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}


resource "aws_cloudwatch_log_group" "peer-vpc" {
  name = "${module.vpc.vpc_id}-flow-logs"
}



resource "aws_iam_role" "vpc-flow-logs" {
  name = "vpc-flowlogs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "example"
  role = aws_iam_role.vpc-flow-logs.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
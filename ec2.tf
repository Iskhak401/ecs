################################################################################
# utils
################################################################################

resource "random_password" "generated_header_value" {
  length = 16
  special = false
}

################################################################################
# setup application load balancers
################################################################################

module "content_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${local.name}-${local.content_resource}-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.content_alb_sg.id]

#   access_logs = {
#     bucket = "alb-logs-s3"
#   }

  target_groups = [
    {
      name= "${local.name}-${local.content_resource}-tg"
      backend_protocol     = "HTTP"
      backend_port         = 5000
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health/ok"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
      protocol_version = "HTTP1"      
      
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]  

  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      priority                = 5000
      actions = [{
        type         = "fixed-response"
        content_type = "application/json"
        status_code  = 403
        message_body = "{\"Message\":\"Invalid request\"}"
      }]

      conditions = [{
        path_patterns = ["/*"]
      }]
    },
    {
      http_tcp_listener_index = 0
      priority                = 1

      actions = [{
        type = "forward"
        target_group_index = 0
         
        stickiness = {
          enabled  = true
          duration = 3600
        }
      }]
      conditions = [{
        http_headers = [{
          http_header_name = local.cloud_custom_header_name
          values           = [local.cloud_custom_header_value]
        }]
      }]
    },
  ]
}

module "identity_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${local.name}-${local.identity_resource}-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.identity_alb_sg.id]

#   access_logs = {
#     bucket = "alb-logs-s3"
#   }

  target_groups = [
    {
      name= "${local.name}-${local.identity_resource}-tg"
      backend_protocol     = "HTTP"
      backend_port         = 5000
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health/ok"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
      protocol_version = "HTTP1"      
      
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]  

  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      priority                = 5000
      actions = [{
        type         = "fixed-response"
        content_type = "application/json"
        status_code  = 403
        message_body = "{\"Message\":\"Invalid request\"}"
      }]

      conditions = [{
        path_patterns = ["/*"]
      }]
    },
    {
      http_tcp_listener_index = 0
      priority                = 1

      actions = [{
        type = "forward"        
        target_group_index = 0        
        stickiness = {
          enabled  = true
          duration = 3600
        }
      }]
      conditions = [{
        http_headers = [{
          http_header_name = local.cloud_custom_header_name
          values           = [local.cloud_custom_header_value]
        }]
      }]
    },
  ]
}

################################################################################
# setup security groups
################################################################################

#content
resource "aws_security_group" "content_alb_sg" {
  name        = "${local.name}-${local.content_resource}-alb-sg"
  description = "Allow HTTP to Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [local.anywhere_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}

resource "aws_security_group" "content_service_sg" {
  name        = "${local.name}-${local.content_resource}-service-sg"
  description = "Allow access to ECS instance from Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request from Load Balancer"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups = [aws_security_group.content_alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}

resource "aws_security_group" "content_rds_sg" {
  name        = "${local.name}-${local.content_resource}-rds-sg"
  description = "Allow access to RDS instance from Local"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request to postgresql"
    from_port        = var.db_port
    to_port          = var.db_port
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}

#Cache
resource "aws_security_group" "redis_sg" {
  name        = "${local.name}-${local.content_resource}-redis-sg"
  description = "Allow access to Redis instance from Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request to postgresql"
    from_port        = var.redis_port
    to_port          = var.redis_port
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}

#Identity
resource "aws_security_group" "identity_alb_sg" {
  name        = "${local.name}-${local.identity_resource}-alb-sg"
  description = "Allow HTTP to Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [local.anywhere_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}

resource "aws_security_group" "identity_service_sg" {
  name        = "${local.name}-${local.identity_resource}-service-sg"
  description = "Allow access to ECS instance from Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request from Load Balancer"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups = [aws_security_group.identity_alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}
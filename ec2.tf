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

module "friends_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${local.name}-${local.friends_resource}-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.friends_alb_sg.id]

#   access_logs = {
#     bucket = "alb-logs-s3"
#   }

  target_groups = [
    {
      name= "${local.name}-${local.friends_resource}-tg"
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

module "chat_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${local.name}-${local.chat_resource}-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.chat_alb_sg.id]

#   access_logs = {
#     bucket = "alb-logs-s3"
#   }

  target_groups = [
    {
      name= "${local.name}-${local.chat_resource}-tg"
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

#Friends
resource "aws_security_group" "friends_alb_sg" {
  name        = "${local.name}-${local.friends_resource}-alb-sg"
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

resource "aws_security_group" "friends_service_sg" {
  name        = "${local.name}-${local.friends_resource}-service-sg"
  description = "Allow access to ECS instance from Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request from Load Balancer"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups = [aws_security_group.friends_alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}

resource "aws_security_group" "friends_docdb_sg" {
  name        = "${local.name}-${local.friends_resource}-docdb-sg"
  description = "Allow access to docdb instance from Local"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request to postgresql"
    from_port        = var.docdb_port_number
    to_port          = var.docdb_port_number
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
  name        = "${local.name}-${local.friends_resource}-redis-sg"
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

#Chat
resource "aws_security_group" "chat_alb_sg" {
  name        = "${local.name}-${local.chat_resource}-alb-sg"
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

resource "aws_security_group" "chat_service_sg" {
  name        = "${local.name}-${local.chat_resource}-service-sg"
  description = "Allow access to ECS instance from Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow request from Load Balancer"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups = [aws_security_group.chat_alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.anywhere_ip]
  } 
}
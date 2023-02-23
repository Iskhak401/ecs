################################################################################
# setup ecs cluster
################################################################################

#friends
resource "aws_ecs_cluster" "peer_ecs_cluster" {
  name = "${local.name}-${local.env}-ecs-cluster"
}

# #chat
# resource "aws_ecs_cluster" "chat_ecs_cluster" {
#   name = "${local.name}-${local.chat_resource}-ecs-cluster"
# }

# #user
# resource "aws_ecs_cluster" "user_ecs_cluster" {
#   name = "${local.name}-${local.user_resource}-ecs-cluster"
# }

################################################################################
# setup task definition
################################################################################

#friends
resource "aws_ecs_task_definition" "friends_task_definition" {
  family                   = "${local.name}-${local.friends_resource}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu_unit
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = <<TASK_DEFINITION
[
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${local.name}-${local.friends_resource}-task-definition",
          "awslogs-region": "${local.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": null,
      "portMappings": [
        {
          "hostPort": ${var.container_port},
          "protocol": "tcp",
          "containerPort": ${var.container_port}
        }
      ],
      "command": null,
      "linuxParameters": null,
      "cpu": 0,
      "environment": [],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__S3BUCKET::",
          "name": "APPCONFIG__S3BUCKET"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:AWS__AccessKey::",
          "name": "AWS__AccessKey"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:AWS__SecretKey::",
          "name": "AWS__SecretKey"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:ConnectionStrings__MongoDB::",
          "name": "ConnectionStrings__MongoDB"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:ConnectionStrings__Redis::",
          "name": "ConnectionStrings__Redis"
        },    
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__MONGODB::",
          "name": "APPCONFIG__MONGODB"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__Key::",
          "name": "JWT__Key"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__Audience::",
          "name": "JWT__Audience"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ExpirationInHours::",
          "name": "JWT__ExpirationInHours"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ValidateAudience::",
          "name": "JWT__ValidateAudience"
        },   
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ValidateIssuer::",
          "name": "JWT__ValidateIssuer"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__Issuer::",
          "name": "JWT__Issuer"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ValidateKey::",
          "name": "JWT__ValidateKey"
        },  
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__EnableInviteSMS::",
          "name": "APPCONFIG__EnableInviteSMS"
        }, 
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:EnableRandomRecommendedFriends::",
          "name": "EnableRandomRecommendedFriends"
        }, 
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__AWSCertificateName::",
          "name": "APPCONFIG__AWSCertificateName"
        }  
      ],
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 1024,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "${module.friends_ecr.repository_url}",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": null,
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": "${local.name}-${local.friends_resource}-container"
    }
]
TASK_DEFINITION
  
}

# #chat
# resource "aws_ecs_task_definition" "chat_task_definition" {
#   family                   = "${local.name}-${local.chat_resource}-task-definition"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = var.task_cpu_unit
#   memory                   = var.task_memory
#   execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
#   container_definitions    = <<TASK_DEFINITION
# [
#     {
#       "dnsSearchDomains": null,
#       "environmentFiles": null,
#       "logConfiguration": {
#         "logDriver": "awslogs",
#         "secretOptions": null,
#         "options": {
#           "awslogs-group": "/ecs/${local.name}-${local.chat_resource}-task-definition",
#           "awslogs-region": "${local.region}",
#           "awslogs-stream-prefix": "ecs"
#         }
#       },
#       "entryPoint": null,
#       "portMappings": [
#         {
#           "hostPort": ${var.container_port},
#           "protocol": "tcp",
#           "containerPort": ${var.container_port}
#         }
#       ],
#       "command": null,
#       "linuxParameters": null,
#       "cpu": 0,
#       "environment": [],
#       "resourceRequirements": null,
#       "ulimits": null,
#       "dnsServers": null,
#       "mountPoints": [],
#       "workingDirectory": null,
#       "secrets": [
#         {
#           "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__S3BUCKET::",
#           "name": "APPCONFIG__S3BUCKET"
#         },
#         {
#           "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:AWS__AccessKey::",
#           "name": "AWS__AccessKey"
#         },
#         {
#           "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:AWS__SecretKey::",
#           "name": "AWS__SecretKey"
#         },
#         {
#           "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:ConnectionStrings__MongoDB::",
#           "name": "ConnectionStrings__MongoDB"
#         },
#         {
#           "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:ConnectionStrings__Redis::",
#           "name": "ConnectionStrings__Redis"
#         },    
#         {
#           "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__MONGODB::",
#           "name": "APPCONFIG__MONGODB"
#         }      
#       ],
#       "dockerSecurityOptions": null,
#       "memory": null,
#       "memoryReservation": 1024,
#       "volumesFrom": [],
#       "stopTimeout": null,
#       "image": "${module.chat_ecr.repository_url}",
#       "startTimeout": null,
#       "firelensConfiguration": null,
#       "dependsOn": null,
#       "disableNetworking": null,
#       "interactive": null,
#       "healthCheck": null,
#       "essential": true,
#       "links": null,
#       "hostname": null,
#       "extraHosts": null,
#       "pseudoTerminal": null,
#       "user": null,
#       "readonlyRootFilesystem": null,
#       "dockerLabels": null,
#       "systemControls": null,
#       "privileged": null,
#       "name": "${local.name}-${local.chat_resource}-container"
#     }
# ]
# TASK_DEFINITION
  
# }

#user
resource "aws_ecs_task_definition" "user_task_definition" {
  family                   = "${local.name}-${local.user_resource}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu_unit
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = <<TASK_DEFINITION
[
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${local.name}-${local.user_resource}-task-definition",
          "awslogs-region": "${local.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": null,
      "portMappings": [
        {
          "hostPort": ${var.container_port},
          "protocol": "tcp",
          "containerPort": ${var.container_port}
        }
      ],
      "command": null,
      "linuxParameters": null,
      "cpu": 0,
      "environment": [],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__S3BUCKET::",
          "name": "APPCONFIG__S3BUCKET"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:AWS__AccessKey::",
          "name": "AWS__AccessKey"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:AWS__SecretKey::",
          "name": "AWS__SecretKey"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:ConnectionStrings__MongoDB::",
          "name": "ConnectionStrings__MongoDB"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:ConnectionStrings__Redis::",
          "name": "ConnectionStrings__Redis"
        },    
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:APPCONFIG__MONGODB::",
          "name": "APPCONFIG__MONGODB"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__Key::",
          "name": "JWT__Key"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__Audience::",
          "name": "JWT__Audience"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ExpirationInHours::",
          "name": "JWT__ExpirationInHours"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ValidateAudience::",
          "name": "JWT__ValidateAudience"
        },   
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ValidateIssuer::",
          "name": "JWT__ValidateIssuer"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__Issuer::",
          "name": "JWT__Issuer"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.peer_secret.id}:JWT__ValidateKey::",
          "name": "JWT__ValidateKey"
        }
      ],
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 1024,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "${module.user_ecr.repository_url}",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": null,
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": "${local.name}-${local.user_resource}-container"
    }
]
TASK_DEFINITION
  
}


################################################################################
# setup cluster service
################################################################################

#friends
# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "friends_task_definition" {
  task_definition = aws_ecs_task_definition.friends_task_definition.family
}

resource "aws_ecs_service" "friends_service" {
  name          = "${local.name}-${local.friends_resource}-service"
  cluster       = aws_ecs_cluster.peer_ecs_cluster.id
  desired_count = 1
  launch_type = "FARGATE"
  force_new_deployment = true
  

  # Track the latest ACTIVE revision
  task_definition = data.aws_ecs_task_definition.friends_task_definition.arn

  load_balancer {
    #elb_name = module.friends_alb.lb_id
    target_group_arn = module.friends_alb.target_group_arns[0]
    container_name = "${local.name}-${local.friends_resource}-container"
    container_port = var.container_port
  }

  network_configuration {
    subnets = [ module.vpc.private_subnets[0], module.vpc.private_subnets[1] ]
    assign_public_ip = false
    security_groups = [ aws_security_group.friends_service_sg.id]
  }
}

# #chat
# # Simply specify the family to find the latest ACTIVE revision in that family.
# data "aws_ecs_task_definition" "chat_task_definition" {
#   task_definition = aws_ecs_task_definition.chat_task_definition.family
# }

# resource "aws_ecs_service" "chat_service" {
#   name          = "${local.name}-${local.chat_resource}-service"
#   cluster       = aws_ecs_cluster.chat_ecs_cluster.id
#   desired_count = 2
#   launch_type = "FARGATE"
#   force_new_deployment = true

  

#   # Track the latest ACTIVE revision
#   task_definition = data.aws_ecs_task_definition.chat_task_definition.arn

#   load_balancer {
#     #elb_name = module.chat_alb.lb_id
#     target_group_arn = module.chat_alb.target_group_arns[0]
#     container_name = "${local.name}-${local.chat_resource}-container"
#     container_port = var.container_port
#   }

#   network_configuration {
#     subnets = [ module.vpc.private_subnets[0], module.vpc.private_subnets[1] ]
#     assign_public_ip = false
#     security_groups = [ aws_security_group.chat_service_sg.id]
#   }
# }

#user
# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "user_task_definition" {
  task_definition = aws_ecs_task_definition.user_task_definition.family
}

resource "aws_ecs_service" "user_service" {
  name          = "${local.name}-${local.user_resource}-service"
  cluster       = aws_ecs_cluster.peer_ecs_cluster.id
  desired_count = 1
  launch_type = "FARGATE"
  force_new_deployment = true

  

  # Track the latest ACTIVE revision
  task_definition = data.aws_ecs_task_definition.user_task_definition.arn

  load_balancer {
    #elb_name = module.chat_alb.lb_id
    target_group_arn = module.user_alb.target_group_arns[0]
    container_name = "${local.name}-${local.user_resource}-container"
    container_port = var.container_port
  }

  network_configuration {
    subnets = [ module.vpc.private_subnets[0], module.vpc.private_subnets[1] ]
    assign_public_ip = false
    security_groups = [ aws_security_group.user_service_sg.id]
  }
}


###########################################################################
#### AWS CloudWatch Logs for Fargate ###########
###########################################################################

resource "aws_cloudwatch_log_group" "friends-logs" {
  name              = "/ecs/${local.name}-${local.friends_resource}-task-definition"
  retention_in_days = var.logs_retention_in_days
}

# resource "aws_cloudwatch_log_group" "chat-logs" {
#   name              = "/ecs/${local.name}-${local.chat_resource}-task-definition"
#   retention_in_days = var.logs_retention_in_days
# }

resource "aws_cloudwatch_log_group" "user-logs" {
  name              = "/ecs/${local.name}-${local.user_resource}-task-definition"
  retention_in_days = var.logs_retention_in_days
}
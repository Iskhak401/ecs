################################################################################
# setup ecs cluster
################################################################################

#content
resource "aws_ecs_cluster" "content_ecs_cluster" {
  name = "${local.name}-${local.content_resource}-ecs-cluster"
}

#identity
resource "aws_ecs_cluster" "identity_ecs_cluster" {
  name = "${local.name}-${local.identity_resource}-ecs-cluster"
}

################################################################################
# setup task definition
################################################################################

#content
resource "aws_ecs_task_definition" "content_task_definition" {
  family                   = "${local.name}-${local.content_resource}-task-definition"
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
          "awslogs-group": "/ecs/${local.name}-${local.content_resource}-task-definition",
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
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:APPCONFIG__GOOGLEAPIKEY::",
          "name": "APPCONFIG__GOOGLEAPIKEY"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:APPCONFIG__NEARBYRADIUS::",
          "name": "APPCONFIG__NEARBYRADIUS"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:APPCONFIG__QUANTUMLEDGERNAME::",
          "name": "APPCONFIG__QUANTUMLEDGERNAME"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:APPCONFIG__S3BUCKET::",
          "name": "APPCONFIG__S3BUCKET"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:APPCONFIG__TOMTOMKEY::",
          "name": "APPCONFIG__TOMTOMKEY"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:AWS__AccessKey::",
          "name": "AWS__AccessKey"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:AWS__SecretKey::",
          "name": "AWS__SecretKey"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:ConnectionStrings__MongoDB::",
          "name": "ConnectionStrings__MongoDB"
        },
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:ConnectionStrings__Redis::",
          "name": "ConnectionStrings__Redis"
        },    
        {
          "valueFrom": "${aws_secretsmanager_secret.content_secret.id}:APPCONFIG__MONGODB::",
          "name": "APPCONFIG__MONGODB"
        }      
      ],
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 1024,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "${module.content_ecr.repository_url}",
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
      "name": "${local.name}-${local.content_resource}-container"
    }
]
TASK_DEFINITION
  
}

#identity
resource "aws_ecs_task_definition" "identity_task_definition" {
  family                   = "${local.name}-${local.identity_resource}-task-definition"
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
          "awslogs-group": "/ecs/${local.name}-${local.identity_resource}-task-definition",
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
          "valueFrom": "${aws_secretsmanager_secret.identity_secret.id}:AppConfig__IdentityServerUrl::",
          "name": "AppConfig__IdentityServerUrl"
        }
      ],
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 1024,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "${module.identity_ecr.repository_url}",
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
      "name": "${local.name}-${local.identity_resource}-container"
    }
]
TASK_DEFINITION
  
}

################################################################################
# setup cluster service
################################################################################

#content
# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "content_task_definition" {
  task_definition = aws_ecs_task_definition.content_task_definition.family
}

resource "aws_ecs_service" "content_service" {
  name          = "${local.name}-${local.content_resource}-service"
  cluster       = aws_ecs_cluster.content_ecs_cluster.id
  desired_count = 2
  launch_type = "FARGATE"
  force_new_deployment = true
  

  # Track the latest ACTIVE revision
  task_definition = data.aws_ecs_task_definition.content_task_definition.arn

  load_balancer {
    #elb_name = module.content_alb.lb_id
    target_group_arn = module.content_alb.target_group_arns[0]
    container_name = "${local.name}-${local.content_resource}-container"
    container_port = var.container_port
  }

  network_configuration {
    subnets = [ module.vpc.private_subnets[0], module.vpc.private_subnets[1] ]
    assign_public_ip = false
    security_groups = [ aws_security_group.content_service_sg.id]
  }
}

#identity
# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "identity_task_definition" {
  task_definition = aws_ecs_task_definition.identity_task_definition.family
}

resource "aws_ecs_service" "identity_service" {
  name          = "${local.name}-${local.identity_resource}-service"
  cluster       = aws_ecs_cluster.identity_ecs_cluster.id
  desired_count = 2
  launch_type = "FARGATE"
  force_new_deployment = true

  

  # Track the latest ACTIVE revision
  task_definition = data.aws_ecs_task_definition.identity_task_definition.arn

  load_balancer {
    #elb_name = module.identity_alb.lb_id
    target_group_arn = module.identity_alb.target_group_arns[0]
    container_name = "${local.name}-${local.identity_resource}-container"
    container_port = var.container_port
  }

  network_configuration {
    subnets = [ module.vpc.private_subnets[0], module.vpc.private_subnets[1] ]
    assign_public_ip = false
    security_groups = [ aws_security_group.identity_service_sg.id]
  }
}


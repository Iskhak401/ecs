variable "aws_region" {
  description = "AWS region for all resources."

  type = string
  default = "us-west-2"
}

variable "environment" {
  description = "dev | staging | production"

  type = string
  default = "dev"
}

variable "project" {
  description = "name of project to identify resources"

  type = string
  default = "peer"
}

variable "owner" {
  description = "name of project owner to identify resources"

  type = string
  default = "peer"
}

variable "max_ecr_image"{
    description = "max number of stored ecr images"

    type= number
    default = 20
}

variable "redis_node_type"{
  description = "redis instance node type"

  default = "cache.t4g.small"
}


variable "redis_num_cache_nodes"{
  description = "number of redis nodes running"

  default = 1
}

variable "cloudfront_custom_header_name"{
  description = "custom header to be use between cf and alb"

  default = "X-Front-Header"
}

variable "api_domain"{
  description = "domain for api"

  default="api.peer.inc"
}

variable "content_subdomain"{
  description = "domain for api"

  default="api.peer.inc"
}

variable "identity_subdomain"{
  description = "domain for api"

  default="api.peer.inc"
}

variable "container_port"{
  description = "docker container exposed port"

  default = 5000
}

variable "task_cpu_unit"{
  description = "ecs task definition cpu unit size"

  default = 512
}

variable "task_memory"{
  description = "ecs task definition cpu memory size"

  default = 1024
}

variable "db_engine_version"{
  description = "db engine version number"

  default= 14.4
}

variable "db_instance_class" {
  description= "instanes class to be use in rds aurora"

  default= "db.t3.micro"
}

variable "db_engine"{
  description= "engine to be use in aurora db"

  default= "aurora-postgresql"
}

variable "db_cluster_size"{
  description= "number of instances that will be running in the cluster"

  default=2
}

variable "db_username"{
  description= "user to access db"

  default= "content_db_user"
}
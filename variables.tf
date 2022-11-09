variable "aws_region" {
  description = "AWS region for all resources."

  type = string
  default = "us-west-2"
}

variable "environment" {
  description = "dev | staging | production"

  type = string  
}

variable "project" {
  description = "name of project to identify resources"

  type = string  
}

variable "owner" {
  description = "name of project owner to identify resources"

  type = string
  default = "peer"
}

variable "vpc_cidr_block"{
  description = "application cidr block"

  default= "10.0.0.0/16"
}

variable "vpc_subnet_cidr_blocks" {
  description = "cidrs blocks allocated in subnets"

  type= list
  default = [ "10.0.0.0/24",
              "10.0.1.0/24",
              "10.0.2.0/24",
              "10.0.3.0/24",
              "10.0.4.0/24",
              "10.0.5.0/24",
              "10.0.6.0/24",
              "10.0.7.0/24",
              "10.0.8.0/24",
              "10.0.9.0/24" ]
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

  default = 2
}

variable "redis_port"{
  description= "redis port configuration"

  default= 6379
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

  default= "db.t4g.medium"
}

variable "db_engine"{
  description= "engine to be use in aurora db"

  default= "aurora-postgresql"
}

variable "db_cluster_size"{
  description= "number of instances that will be running in the cluster"

  default=2
}

variable "db_port"{
  description= "db connection port"

  default=5432
}

variable "db_username"{
  description= "user to access db"

  default= "content_db_user"
}

variable "google_api_key"{
  description= "Google API key for maps"

  default= ""
}

variable "nearby_radius"{
  description= "Nearby radius"

  default= 1500
}

variable "mobidev_identity_api"{
  description = "mobidev identity api"

  default= "beta.api.peer.inc"
}
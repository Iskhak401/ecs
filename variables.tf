variable "aws_region" {
  description = "AWS region for all resources."

  type = string
  default = "us-west-2"
}

variable "aws_access_key" {
  description = "AWS user access key."

  type = string  
}

variable "aws_secret_key" {
  description = "AWS user secret key."

  type = string  
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
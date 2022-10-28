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
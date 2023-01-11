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

variable "google_api_key"{
  description= "Google API key for maps"
  default = ""
}

variable "tomtom_api_key"{
  description= "Tomtom API key for locations"
  default = ""
}

variable "nearby_radius"{
  description= "Nearby radius"
  default = 1500
}

variable "mobidev_identity_api"{
  description = "mobidev identity api"
  default = "beta.api.peer.inc"
}

###########################################
### Docdb variable set #######
###########################################

variable "db_name" {
    description = "Cluster Identifier"
    type = string
    default = "peer"
}

variable "engine" {
    description = "CLuster engine"
    type = string
    default = "docdb"
}

variable "db_username" {
    description = "DB username"
    type = string
    default = "content_db_user"
}

variable "backup_retention_period" {
    description = "backup_retention_period"
    type = string
    default = "5"
}

variable "backup_window" {
    description = "backup window"
    type = string
    default = "07:00-09:00"
}

variable "docdb_port_number" {
    description = "Cluster port"
    type = string
    default = "27017"
}

variable "instance_count" {
    description = "Cluster Instance count"
    type = string 
    default = "2"
}

variable "instance_class" {
    description = "instance type"
    type = string 
    default = "db.t4g.medium"
}

variable "family_id" {
    description = "cluster group parameter family id"
    type = string
    default = "docdb4.0"
}

variable "pg_name_prefix" {
    description = "parameter group name prefix"
    type = string
    default = "pg"
}

variable "parameter_name"  {
    description = "Parameter name for tls"
    type = string
    default = "tls"
}

variable "parameter_value" {
    description = "parameter value for tls" 
    type = string
    default = "enabled"
}

variable "vpc_id" {
  description = "ID of the VPC to deploy database into."
  type        = string
  default = "vpc-0fc3142e2880d04ce"
}

variable "vpc_subnet_cidr_blocks" {
  description = "cidrs blocks allocated in subnets"
  type = list
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

variable "cloudwatch_logs" {
    description = "Logs to send to CLoudWatch"
    type = list(string)
    default = ["audit"]
}

variable "region" {
    description = "region"
    type = string
    default = "us-west-2"
}


variable "vpc_cidr_block"{
  description = "application cidr block"
  default = "10.0.0.0/16"
}
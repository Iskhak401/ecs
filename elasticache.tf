################################################################################
# setup redis cluster
################################################################################

resource "aws_elasticache_cluster" "content_redis" {
  cluster_id           = "${local.name}-${local.content_resource}-cache-cluster"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_num_cache_nodes
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = module.vpc.elasticache_subnet_group_name
  security_group_ids   = [aws_security_group.redis_sg.id]
}

################################################################################
# setup elasticache subnet group
################################################################################

#subnet created by module.vpc
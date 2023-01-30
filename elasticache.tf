################################################################################
# setup redis cluster
################################################################################

resource "aws_elasticache_cluster" "friends_redis" {
  cluster_id           = "${local.name}-${local.friends_resource}-cache"
  #num_cache_nodes      = var.redis_num_cache_nodes
  replication_group_id = aws_elasticache_replication_group.friends_redis_replica.id
}
resource "aws_elasticache_replication_group" "friends_redis_replica" {
  automatic_failover_enabled  = true
  preferred_cache_cluster_azs = ["${local.region}a", "${local.region}b"]
  engine                      = "redis"
  replication_group_id        = "${local.name}-rep-group-1"
  description                 = "Peer app replication redis config"
  node_type                   = var.redis_node_type
  num_cache_clusters          = var.redis_num_cache_nodes
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                        = var.redis_port
  
  subnet_group_name    = module.vpc.elasticache_subnet_group_name
  security_group_ids   = [aws_security_group.redis_sg.id]

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }
}

data "aws_elasticache_replication_group" "friends_redis_replica" {
  replication_group_id = aws_elasticache_replication_group.friends_redis_replica.id
}

################################################################################
# setup elasticache subnet group
################################################################################

#subnet created by module.vpc
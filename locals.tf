locals{
    name = var.project
    env = var.environment
    region = var.aws_region

    vpc_acl_default_block_all = [ { "cidr_block": local.anywhere_ip, 
                                   "from_port": 0,
                                   "to_port": 0, 
                                   "protocol": "-1", 
                                   "rule_action": "deny", 
                                   "rule_number": 20000 } ]
    vpc_acl_default_outbound_service = [ { "cidr_block": local.anywhere_ip, 
                                   "from_port": 1025,
                                   "to_port": 65535, 
                                   "protocol": "tcp", 
                                   "rule_action": "deny", 
                                   "rule_number": 19000 } ]

    qldb_ledger = aws_qldb_ledger.content_ledger.name
    google_key = var.google_api_key
    nearbyradius = var.nearby_radius
    app_access_key = module.app_user.iam_access_key_id
    app_secret_key = module.app_user.iam_access_key_secret
    redis_string = data.aws_elasticache_replication_group.content_redis_replica.primary_endpoint_address
    postgres_string = "Server=${module.content_rds.cluster_endpoint};Port=${var.db_port};Database=${local.name}-${local.content_resource}-${local.env};User Id=${var.db_username};password=${local.rds_password};Timeout=20;"
    s3_bucket = module.s3_bucket.s3_bucket_id
    

    content_resource = "content"
    identity_resource = "identity"
    max_ecr = var.max_ecr_image
    anywhere_ip = "0.0.0.0/0"

    cloud_custom_header_name = var.cloudfront_custom_header_name
    cloud_custom_header_value = random_password.generated_header_value.result

    mobidev_identity_api = var.mobidev_identity_api
    api_domain = var.api_domain
    content_subdomain = var.content_subdomain
    identity_subdomain = var.identity_subdomain

    rds_engine = var.db_engine
    rds_password = random_password.generated_rds_password.result
    rds_user = var.db_username
}
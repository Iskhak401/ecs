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
                                   "rule_action": "allow", 
                                   "rule_number": 19000 } ]

    app_access_key = module.app_user.iam_access_key_id
    app_secret_key = module.app_user.iam_access_key_secret
    redis_string = data.aws_elasticache_replication_group.friends_redis_replica.primary_endpoint_address
    mongoDB_string = "mongodb://${var.db_username}:${local.docdb_password}@${aws_docdb_cluster.service.endpoint}:${var.docdb_port_number}/${local.db_name}?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
    s3_bucket = module.s3_bucket.s3_bucket_id
    s3_bucket_url = "https://${module.s3_bucket.s3_bucket_domain_name}"
    db_name = "${var.db_name}-${var.environment}"
    

    friends_resource = "friends"
    chat_resource = "chat"
    chat_server_resource = "chat-server"
    user_resource = "user"
    max_ecr = var.max_ecr_image
    anywhere_ip = "0.0.0.0/0"

    cloud_custom_header_name = var.cloudfront_custom_header_name
    cloud_custom_header_value = random_password.generated_header_value.result

    proxy_postgres_string = var.proxy_postgres_string
    api_domain = var.api_domain
    friends_subdomain = var.friends_subdomain
    # chat_subdomain = var.chat_subdomain

    docdb_engine = var.engine
    docdb_password = random_password.generated_docdb_password.result
    docdb_user = var.db_username
}
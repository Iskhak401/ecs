locals{
    name = var.project
    env = var.environment
    region = var.aws_region

    qldb_ledger = "" #pending_resource
    google_key = "" #pending_resource
    nearbyradius = "" #pending_resource
    app_access_key = "" #pending_resource
    app_secret_key = "" #pending_resource
    redis_string = "" #pending_resource
    postgres_string = "" #pending_resource

    content_resource = "content"
    identity_resource = "identity"
    max_ecr = var.max_ecr_image
    anywhere_ip = "0.0.0.0/0"

    cloud_custom_header_name = var.cloudfront_custom_header_name
    cloud_custom_header_value = random_password.generated_header_value.result

    mobidev_identity_api = "" #pending_resource
    api_domain = var.api_domain
    content_subdomain = var.content_subdomain
    identity_subdomain = var.identity_subdomain
}
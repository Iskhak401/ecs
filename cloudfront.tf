################################################################################
# setup cloudfront
################################################################################

module "content_cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["${local.content_subdomain}-${local.env}.${local.api_domain}"]

  comment             = "${local.name} ${local.content_resource} API Cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false  

#   logging_config = {
#     bucket = module.log_bucket.s3_bucket_bucket_domain_name
#     prefix = "cloudfront"
#   }

  origin = {
    alb = {
      domain_name = module.content_alb.lb_dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }

      custom_header = [
        {
          name  = local.cloud_custom_header_name
          value = local.cloud_custom_header_value
        }
        
      ]      
    }

  }

  default_cache_behavior = {
    target_origin_id            = "alb"
    viewer_protocol_policy      = "https-only"
    allowed_methods             = ["GET", "HEAD", "OPTIONS","PUT", "POST","PATCH","DELETE"]
    cached_methods              = []
    compress                    = true
    query_string                = true
    origin_request_policy_id    = aws_cloudfront_origin_request_policy.content_origin_policy.id
    cache_policy_id             = aws_cloudfront_cache_policy.content_cache_policy.id    
  }
}

module "identity_cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["${local.identity_subdomain}-${local.env}.${local.api_domain}"]

  comment             = "${local.name} ${local.identity_resource} API Cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false  

#   logging_config = {
#     bucket = module.log_bucket.s3_bucket_bucket_domain_name
#     prefix = "cloudfront"
#   }

  origin = {
    alb = {
      domain_name = module.identity_alb.lb_dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }

      custom_header = [
        {
          name  = local.cloud_custom_header_name
          value = local.cloud_custom_header_value
        }
        
      ]
    }

  }

  default_cache_behavior = {
    target_origin_id            = "alb"
    viewer_protocol_policy      = "https-only"
    allowed_methods             = ["GET", "HEAD", "OPTIONS","PUT", "POST","PATCH","DELETE"]
    cached_methods              = []
    compress                    = true
    query_string                = true
    origin_request_policy_id    = aws_cloudfront_origin_request_policy.content_origin_policy.id
    cache_policy_id             = aws_cloudfront_cache_policy.content_cache_policy.id
  }
}


################################################################################
# setup origin request policy
################################################################################

resource "aws_cloudfront_origin_request_policy" "content_origin_policy" {
  name    = "${local.name}-origin-policy"
  comment = "Send all info to origin"
  cookies_config {
    cookie_behavior = "all"    
  }
  headers_config {
    header_behavior = "allViewer"    
  }
  query_strings_config {
    query_string_behavior = "all"    
  }
}

################################################################################
# setup cache policy
################################################################################

resource "aws_cloudfront_cache_policy" "content_cache_policy" {
  name        = "${local.name}-cache-policy"
  comment     = "Disable cloudfront cache"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"      
    }
    headers_config {
      header_behavior = "none"      
    }
    query_strings_config {
      query_string_behavior = "none"      
    }
  }
}
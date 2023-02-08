################################################################################
# setup cloudfront
################################################################################

module "friends_cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  #aliases = ["${local.friends_subdomain}-${local.env}.${local.api_domain}"]

  comment             = "${local.name} ${local.friends_resource} API Cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false  
  web_acl_id          = aws_wafv2_web_acl.peer_cloudfront_acl.arn

#   logging_config = {
#     bucket = module.log_bucket.s3_bucket_bucket_domain_name
#     prefix = "cloudfront"
#   }

  origin = {
    alb = {
      domain_name = module.friends_alb.lb_dns_name
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
    cached_methods              = ["GET", "HEAD"]
    compress                    = true
    query_string                = true
    origin_request_policy_id    = aws_cloudfront_origin_request_policy.friends_origin_policy.id
    cache_policy_id             = aws_cloudfront_cache_policy.friends_cache_policy.id
    use_forwarded_values        = false
  }
}


module "user_cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  #aliases = ["${local.friends_subdomain}-${local.env}.${local.api_domain}"]

  comment             = "${local.name} ${local.user_resource} API Cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false  
  web_acl_id          = aws_wafv2_web_acl.peer_cloudfront_acl.arn

#   logging_config = {
#     bucket = module.log_bucket.s3_bucket_bucket_domain_name
#     prefix = "cloudfront"
#   }

  origin = {
    alb = {
      domain_name = module.user_alb.lb_dns_name
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
    cached_methods              = ["GET", "HEAD"]
    compress                    = true
    query_string                = true
    origin_request_policy_id    = aws_cloudfront_origin_request_policy.friends_origin_policy.id
    cache_policy_id             = aws_cloudfront_cache_policy.friends_cache_policy.id
    use_forwarded_values        = false
  }
}

# module "chat_cloudfront" {
#   source = "terraform-aws-modules/cloudfront/aws"

#   #aliases = ["${local.chat_subdomain}-${local.env}.${local.api_domain}"]

#   comment             = "${local.name} ${local.chat_resource} API Cloudfront"
#   enabled             = true
#   is_ipv6_enabled     = true
#   price_class         = "PriceClass_All"
#   retain_on_delete    = false
#   wait_for_deployment = false 
#   web_acl_id          = aws_wafv2_web_acl.peer_cloudfront_acl.arn

# #   logging_config = {
# #     bucket = module.log_bucket.s3_bucket_bucket_domain_name
# #     prefix = "cloudfront"
# #   }

#   origin = {
#     alb = {
#       domain_name = module.chat_alb.lb_dns_name
#       custom_origin_config = {
#         http_port              = 80
#         https_port             = 443
#         origin_protocol_policy = "http-only"
#         origin_ssl_protocols   = ["TLSv1.2"]
#       }

#       custom_header = [
#         {
#           name  = local.cloud_custom_header_name
#           value = local.cloud_custom_header_value
#         }
        
#       ]
#     }

#   }

#   default_cache_behavior = {
#     target_origin_id            = "alb"
#     viewer_protocol_policy      = "https-only"
#     allowed_methods             = ["GET", "HEAD", "OPTIONS","PUT", "POST","PATCH","DELETE"]
#     cached_methods              = ["GET", "HEAD"]
#     compress                    = true
#     query_string                = true
#     origin_request_policy_id    = data.aws_cloudfront_origin_request_policy.friends_origin_policy.id
#     cache_policy_id             = data.aws_cloudfront_cache_policy.friends_cache_policy.id
#     use_forwarded_values        = false
#   }
# }


################################################################################
# setup origin request policy
################################################################################

data "aws_cloudfront_origin_request_policy" "friends_origin_policy" {
  name    = "Managed-AllViewer"
}

resource "aws_cloudfront_origin_request_policy" "friends_origin_policy" {
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

data "aws_cloudfront_cache_policy" "friends_cache_policy" {
  name        = "Managed-CachingDisabled"
}

resource "aws_cloudfront_cache_policy" "friends_cache_policy" {
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
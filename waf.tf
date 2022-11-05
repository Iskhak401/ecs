resource "aws_wafv2_web_acl" "peer_cloudfront_acl" {
    provider= aws.cloudfront-global
    
    name  = "${local.name}-api-web-acl"
    scope = "CLOUDFRONT"

    default_action {
        block {}
    }

    rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0
    
    override_action {
      none {}
    }

    statement {
        
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAdminProtectionRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 15

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 25

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "PeerEndpointMetric"
    sampled_requests_enabled   = false
  }

    # rule {
    #     name     = "${local.name}-Api-Rule"
    #     priority = 0

    #     override_action {
    #     none {}
    #     }

    #     statement {
    #     rule_group_reference_statement {
    #         arn = aws_wafv2_rule_group.peer_cloudfront_rule_group.arn        
    #     }
    #     }

    # }  
}


# resource "aws_wafv2_rule_group" "peer_cloudfront_rule_group" {
  
#   name        = "${local.name}-api-rule-group"
#   description = "Cloudfront rules for content and identity endpoints."
#   scope       = "CLOUDFRONT"
#   capacity    = 800

#   rule {
#     name     = "AWSManagedRulesCommonRuleSet"
#     priority = 0
    
#     action {
#       count {}
#     }

#     statement {
        
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesCommonRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesAdminProtectionRuleSet"
#     priority = 5

#     action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAdminProtectionRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAdminProtectionRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesAmazonIpReputationList"
#     priority = 10

#     action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAmazonIpReputationList"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesAnonymousIpList"
#     priority = 15

#     action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAnonymousIpList"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAnonymousIpListMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesKnownBadInputsRuleSet"
#     priority = 20

#     action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesKnownBadInputsRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesLinuxRuleSet"
#     priority = 25

#     action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesLinuxRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }


#   rule {
#     name     = "AWSManagedRulesSQLiRuleSet"
#     priority = 30

#     action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesSQLiRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "PeerEndpointMetric"
#     sampled_requests_enabled   = false
#   }
# }
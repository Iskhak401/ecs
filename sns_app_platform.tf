resource "aws_sns_platform_application" "apns" {
  name     = "${local.env}-${local.name}-apns-app"
  platform = "APNS"
  platform_principal = var.sns_platform_private_key
  platform_credential = var.sns_platform_certificate 
}

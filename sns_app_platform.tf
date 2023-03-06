# data "pkcs12_archive" "apns_certificate" {
#   archive  = filebase64("${path.module}/iOS_apns_cert/APNSSandboxCertificates.p12")
#   password = var.apns_certificate_password
# }
# resource "aws_sns_platform_application" "apns" {
#   name     = "${local.env}-${local.name}-apns-app"
#   platform = "APNS_SANDBOX"
#   platform_principal = data.pkcs12_archive.apns_certificate.certificate
#   platform_credential = data.pkcs12_archive.apns_certificate.private_key
# }

resource "aws_sns_platform_application" "gcm" {
  name     = "${local.env}-${local.name}-gcm-app"
  platform            = "GCM"
  platform_credential = var.gcm_api_key
}
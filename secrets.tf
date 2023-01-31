################################################################################
# setup secret
################################################################################

resource "aws_secretsmanager_secret" "peer_secret" {
  name = "${local.name}-${local.env}-sm"
}

################################################################################
# setup secret values
################################################################################

resource "aws_secretsmanager_secret_version" "peer_version" {
  secret_id = aws_secretsmanager_secret.peer_secret.id
  secret_string = jsonencode({

    "APPCONFIG__S3BUCKET" = local.s3_bucket
    "AWS__AccessKey" = local.app_access_key
    "AWS__SecretKey" = local.app_secret_key
    "ConnectionStrings__Redis" = local.redis_string
    "ConnectionStrings__MongoDB" = local.mongoDB_string
    "APPCONFIG__MONGODB" = local.db_name
    "APPCONFIG__AWSCertificateName" = var.aws_cert_name
  })
}

################################################################################
# setup secret
################################################################################

resource "aws_secretsmanager_secret" "friends_secret" {
  name = "${local.name}-${local.friends_resource}-sm"
}

resource "aws_secretsmanager_secret" "chat_secret" {
  name = "${local.name}-${local.chat_resource}-sm"
}


################################################################################
# setup secret values
################################################################################

resource "aws_secretsmanager_secret_version" "friends_version" {
  secret_id = aws_secretsmanager_secret.friends_secret.id
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

resource "aws_secretsmanager_secret_version" "chat_version" {
  secret_id = aws_secretsmanager_secret.chat_secret.id
  secret_string = jsonencode({
    "AppConfig__chatServerUrl" = local.mobidev_chat_api
    "ConnectionStrings__Postgres" = local.proxy_postgres_string
  })
}


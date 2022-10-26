resource "aws_secretsmanager_secret" "content_api" {
  name = "${local.name}-content"
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.content_api.id
  secret_string = jsonencode({
    "APPCONFIG__QUANTUMLEDGERNAME" = local.qldb_ledger
    "APPCONFIG__GOOGLEAPIKEY" = local.google_key
    "APPCONFIG__NEARBYRADIUS" = local.nearbyradius
    "AWS__AccessKey" = local.app_access_key
    "AWS__SecretKey" = local.app_secret_key
    "ConnectionStrings__Redis" = local.redis_string
    "ConnectionStrings__Postgres" = local.postgres_string
  })
}


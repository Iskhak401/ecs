################################################################################
# setup secret
################################################################################

resource "aws_secretsmanager_secret" "content_secret" {
  name = "${local.name}-${local.content_resource}-sm"
}

resource "aws_secretsmanager_secret" "identity_secret" {
  name = "${local.name}-${local.identity_resource}-sm"
}


################################################################################
# setup secret values
################################################################################

resource "aws_secretsmanager_secret_version" "content_version" {
  secret_id = aws_secretsmanager_secret.content_secret.id
  secret_string = jsonencode({
    "APPCONFIG__QUANTUMLEDGERNAME" = local.qldb_ledger
    "APPCONFIG__GOOGLEAPIKEY" = local.google_key
    "APPCONFIG__NEARBYRADIUS" = local.nearbyradius
    "APPCONFIG__S3BUCKET" = local.s3_bucket
    "APPCONFIG__TOMTOMKEY" = local.tomtom_key
    "AWS__AccessKey" = local.app_access_key
    "AWS__SecretKey" = local.app_secret_key
    "ConnectionStrings__Redis" = local.redis_string
    "ConnectionStrings__MongoDB" = local.mongoDB_string
    "APPCONFIG__MONGODB" = local.db_name
  })
}

resource "aws_secretsmanager_secret_version" "identity_version" {
  secret_id = aws_secretsmanager_secret.identity_secret.id
  secret_string = jsonencode({
    "AppConfig__IdentityServerUrl" = local.mobidev_identity_api
  })
}


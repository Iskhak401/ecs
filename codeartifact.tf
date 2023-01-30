resource "aws_kms_key" "peer_codeartifact" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "peer" {
  domain         = "${local.name}"
  encryption_key = aws_kms_key.peer_codeartifact.arn
}

resource "aws_codeartifact_repository" "peer" {
  repository = "${local.name}-core"
  domain     = aws_codeartifact_domain.peer.domain
}
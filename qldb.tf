resource "aws_qldb_ledger" "content_ledger" {
  name             = "${local.name}-${local.env}-qldb"
  permissions_mode = "STANDARD"
}
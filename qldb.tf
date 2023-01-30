resource "aws_qldb_ledger" "friends_ledger" {
  name             = "${local.name}-${local.env}-qldb"
  permissions_mode = "STANDARD"
}
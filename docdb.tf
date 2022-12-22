resource "random_password" "generated_docdb_password" {
  length  = 16
  special = false
}

resource "aws_docdb_subnet_group" "service" {
  name       = "${local.env}-sg"
  subnet_ids = flatten([module.vpc.private_subnets])
}

resource "aws_docdb_cluster_instance" "service" {
  count              = 2
  identifier         = "${var.db_name}-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.service.id}"
  instance_class     = var.instance_class
}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_docdb_subnet_group.service.name}"
  cluster_identifier      = "${local.env}-${var.db_name}"
  engine                  = var.engine
  master_username         = var.db_username
  master_password         = local.docdb_password
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.service.name}"
  vpc_security_group_ids = ["${aws_security_group.content_docdb_sg.id}"]
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = false
  port = var.port_number
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs
  apply_immediately  = true
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = var.family_id
  name = "${local.env}-${var.pg_name_prefix}"

  parameter {
    name  = var.parameter_name
    value = var.parameter_value
  }
}


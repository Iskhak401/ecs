resource "random_password" "generated_rds_password" {
  length = 16
  special = false
}


module "content_rds"{
    source = "terraform-aws-modules/rds-aurora/aws"

    name= "${local.name}-${local.content_resource}-rds-cluster"
    engine= local.rds_engine
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class

    instances = { for i in range(var.db_cluster_size) : i => {} }

    vpc_id = module.vpc.vpc_id
    db_subnet_group_name = module.vpc.database_subnet_group_name
    vpc_security_group_ids = [ aws_security_group.content_rds_sg.id ]
    create_db_subnet_group = false
    create_security_group = false
    allowed_cidr_blocks = [ module.vpc.vpc_cidr_block ]

    port = var.db_port    

    iam_database_authentication_enabled = true
    master_password = local.rds_password
    create_random_password = false

    apply_immediately = true

    create_db_cluster_parameter_group      = true
    db_cluster_parameter_group_name        = local.name
    db_cluster_parameter_group_family      = "aurora-postgresql14"
    db_cluster_parameter_group_description = "${local.name} example cluster parameter group"
    db_cluster_parameter_group_parameters = [
        {
        name         = "log_min_duration_statement"
        value        = 4000
        apply_method = "immediate"
        }, {
        name         = "rds.force_ssl"
        value        = 1
        apply_method = "immediate"
        }
    ]

    create_db_parameter_group      = true
    db_parameter_group_name        = local.name
    db_parameter_group_family      = "aurora-postgresql14"
    db_parameter_group_description = "${local.name} example DB parameter group"
    db_parameter_group_parameters = [
        {
        name         = "log_min_duration_statement"
        value        = 4000
        apply_method = "immediate"
        }
    ]
}
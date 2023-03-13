################################################################################
# setup iam user
################################################################################

module "app_user"{
    source  = "terraform-aws-modules/iam/aws//modules/iam-user"

    name = "${local.name}-app-user"

    create_iam_user_login_profile = false
    create_iam_access_key         = true
}

module "cicd_user"{
    source  = "terraform-aws-modules/iam/aws//modules/iam-user"

    name = "${local.name}-cicd-user"

    create_iam_user_login_profile = false
    create_iam_access_key         = true
}


module "user_group"{
    source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
    version = "5.5.5"

    name = "${local.name}-app-group"
    group_users = [module.app_user.iam_user_name]

    custom_group_policy_arns = [
        aws_iam_policy.qldb_iam_policy.arn,
        data.aws_iam_policy.AmazonEC2FullAccess.arn,
        data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn,
        data.aws_iam_policy.AmazonS3FullAccess.arn,
        data.aws_iam_policy.ReadOnlyAccess.arn,
        data.aws_iam_policy.AmazonECS_FullAccess.arn,
        data.aws_iam_policy.AmazonSNSFullAccess.arn
    ]
}

module "cicd_group"{
    source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
    version = "5.5.5"

    name = "${local.name}-cicd-group"
    group_users = [module.cicd_user.iam_user_name]

    custom_group_policy_arns = [        
        data.aws_iam_policy.AmazonEC2FullAccess.arn,
        data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn,        
        data.aws_iam_policy.AmazonECS_FullAccess.arn,
        data.aws_iam_policy.AWSCodeArtifactAdminAccess.arn
    ]
}

################################################################################
# setup iam policies and roles
################################################################################

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ecs-tasks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })

    managed_policy_arns = [
        data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn,
        aws_iam_policy.secrets_iam_policy.arn
    ]

}


#qldb
data "aws_iam_policy_document" "qldb_role" {

    statement {
        sid         = "QLDBSendCommandPermission"
        actions     = [ "qldb:SendCommand" ]
        effect      = "Allow"
        resources   = [ aws_qldb_ledger.friends_ledger.arn ]
    }

    statement {
        sid         = "QLDBPartiQLReadOnlyPermissions"
        actions     = [ "qldb:PartiQLReadOnlyPermissions",
                        "qldb:PartiQLSelect"
                    ]
        effect      = "Allow"
        resources   = [ "${aws_qldb_ledger.friends_ledger.arn}/table/*",
                        "${aws_qldb_ledger.friends_ledger.arn}/information_schema/user_tables"
                    ]
    }

    statement {
        sid         = "QLDBPartiQLModifyPermissions"
        actions     = [ "qldb:PartiQLCreateIndex",
                        "qldb:PartiQLCreateTable",
                        "qldb:PartiQLInsert",
                        "qldb:PartiQLSelect",
                        "qldb:PartiQLUpdate"
                    ]
        effect      = "Allow"
        resources   = [ "${aws_qldb_ledger.friends_ledger.arn}/table/*",
                        "${aws_qldb_ledger.friends_ledger.arn}/information_schema/user_tables"
                    ]
    }
}

resource "aws_iam_policy" "qldb_iam_policy" {
    name    = "${local.name}-qldb-policy"
    policy  = data.aws_iam_policy_document.qldb_role.json
}


#secrets manager
data "aws_iam_policy_document" "secrets_role"{
    statement {
        sid         = "ReadSecret"
        actions     = [ "secretsmanager:GetResourcePolicy",
                        "secretsmanager:GetSecretValue",
                        "secretsmanager:DescribeSecret",
                        "secretsmanager:ListSecretVersionIds"
                    ]
        effect      = "Allow"
        resources   = [ aws_secretsmanager_secret.peer_secret.arn
                    ]
    }

    statement {
        sid         = "ReadRandomPassword"
        actions     = [ "secretsmanager:GetRandomPassword" ]
        effect      = "Allow"
        resources   = [ "*" ]
    } 
}

resource "aws_iam_policy" "secrets_iam_policy" {
    name    = "${local.name}-secret-policy"
    policy  = data.aws_iam_policy_document.secrets_role.json
}




################################################################################
# setup aws managed policies
################################################################################
data "aws_iam_policy" "AmazonEC2FullAccess" {
  name = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "SecretsManagerReadWrite" {
  name = "SecretsManagerReadWrite"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryFullAccess" {
  name = "AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "ReadOnlyAccess" {
  name = "ReadOnlyAccess"
}

data "aws_iam_policy" "AmazonECS_FullAccess" {
  name = "AmazonECS_FullAccess"
}

data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "AWSCodeArtifactAdminAccess" {
    name = "AWSCodeArtifactAdminAccess"
}
data "aws_iam_policy" "AmazonSNSFullAccess" {
    name = "AmazonSNSFullAccess"
}
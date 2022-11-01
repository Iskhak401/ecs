################################################################################
# setup iam user
################################################################################

module "app_user"{
    source  = "terraform-aws-modules/iam/aws//modules/iam-user"

    name = "${local.name}-app-user"
}


################################################################################
# setup iam policies and roles
################################################################################

#qldb
data "aws_iam_policy_document" "qldb_role" {

    statement {
        sid         = "QLDBSendCommandPermission"
        actions     = [ "qldb:SendCommand" ]
        effect      = "Allow"
        resources   = [ aws_qldb_ledger.content_ledger.arn ]
    }

    statement {
        sid         = "QLDBPartiQLReadOnlyPermissions"
        actions     = [ "qldb:PartiQLReadOnlyPermissions",
                        "qldb:PartiQLSelect"
                    ]
        effect      = "Allow"
        resources   = [ "${aws_qldb_ledger.content_ledger.arn}/table/*",
                        "${aws_qldb_ledger.content_ledger.arn}/information_schema/user_tables"
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
        resources   = [ "${aws_qldb_ledger.content_ledger.arn}/table/*",
                        "${aws_qldb_ledger.content_ledger.arn}/information_schema/user_tables"
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
        resources   = [ aws_secretsmanager_secret.content_secret.arn,
                        aws_secretsmanager_secret.identity_secret.arn
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
    policy  = data.aws_iam_policy_document.qldb_role.json
}

#TODO create ecsTaskExecutionRole
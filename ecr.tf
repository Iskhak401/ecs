################################################################################
# setup container registry
################################################################################

module "content_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${local.name}-content-ecr"
  
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = local.max_ecr
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

module "identity_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${local.name}-identity-ecr"
  
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = local.max_ecr
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
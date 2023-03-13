################################################################################
# setup container registry
################################################################################

module "friends_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${local.name}-${local.friends_resource}-ecr"
  
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

module "chat_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${local.name}-${local.chat_resource}-ecr"
  
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

module "user_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${local.name}-${local.user_resource}-ecr"
  
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
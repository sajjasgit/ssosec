resource "aws_ecr_repository" "ssosec-ecr" {
  name                 = local.container_repo_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "ssosec-ecr-policy" {
  repository = aws_ecr_repository.ssosec-ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}
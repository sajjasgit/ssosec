resource "aws_ecr_repository" "ssosec_ecr" {
  name                 = "${var.prefix}-ecr-repo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "ssosec_ecr_policy" {
  repository = aws_ecr_repository.ssosec_ecr.name

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
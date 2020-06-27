resource "aws_ecr_repository" "ecr-repository" {
  name                 = "friendlyhello"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
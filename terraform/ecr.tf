resource "aws_ecr_repository" "this" {
  name = "${local.prefix}-ecr-repo"
}

output "ecr_login_command" {
  value = join("", [
    "aws ecr get-login-password --region ",
    data.aws_region.current.name,
    " | docker login --username AWS --password-stdin ",
    aws_ecr_repository.this.repository_url
  ])
}

output "docker_build_command" {
  value = join("", [
    "docker build -t ",
    aws_ecr_repository.this.repository_url,
    ":latest ."
  ])
}

output "docker_tag_command" {
  value = join("", [
    "docker tag ",
    aws_ecr_repository.this.repository_url,
    ":latest ",
    aws_ecr_repository.this.repository_url,
    ":latest"
  ])
}

output "docker_push_command" {
  value = join("", [
    "docker push ",
    aws_ecr_repository.this.repository_url,
    ":latest"
  ])
}

data "aws_region" "current" {}


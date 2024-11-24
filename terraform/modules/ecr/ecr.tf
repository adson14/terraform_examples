resource "aws_ecr_repository" "service_a_repo" {
  name = "service-a"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = "Production"
    Project     = "${var.prefix}-service-a"
  }
}


resource "aws_ecr_repository" "service_b_repo" {
  name = "service-b"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = "Production"
    Project     = "${var.prefix}-service-b"
  }
}

# Output para exibir os URLs do repositório
output "service_a_repo_url" {
  value = aws_ecr_repository.service_a_repo.repository_url
}

output "service_b_repo_url" {
  value = aws_ecr_repository.service_b_repo.repository_url
}

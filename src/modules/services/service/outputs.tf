output "aws_ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_name" {
  value = aws_ecr_repository.backend.name
}

output "dns_name" {
  value = module.alb.dns_name
}
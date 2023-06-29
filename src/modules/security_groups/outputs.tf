output "db" {
  value = aws_security_group.db
}

output "service" {
  value = aws_security_group.ecs_service
}

output "service_alb" {
  value = aws_security_group.service_alb
}

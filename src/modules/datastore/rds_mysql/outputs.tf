output "db_instance_arn" {
  value = module.db.db_instance_arn
}

output "db_instance_address" {
  value = module.db.db_instance_address
}

output "db_subnet_group_id" {
  value = module.db.db_subnet_group_id
}

output "db_instance_port" {
  value = module.db.db_instance_port
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}

output "db_instance_endpoint" {
  value = module.db.db_instance_endpoint
}

output "secrets_arn" {
  value = aws_secretsmanager_secret.db.arn
}
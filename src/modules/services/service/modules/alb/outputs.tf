output "aws_alb_arn" {
  value = aws_alb.main.arn
}

output "aws_alb_dns_name" {
  value = aws_alb.main.dns_name
}

output "dns_name" {
  value = aws_alb.main.dns_name
}

output "aws_alb_target_group_blue" {
  value = aws_alb_target_group.blue
}

output "aws_alb_target_group_green" {
  value = aws_alb_target_group.green
}

output "aws_alb_target_group_api" {
  value = aws_alb_target_group.api
}

output "aws_alb_listener_prod" {
  value = aws_alb_listener.prod
}

output "aws_alb_listener_test" {
  value = aws_alb_listener.test
}
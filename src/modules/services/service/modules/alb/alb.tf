resource "aws_alb" "main" {
  name               = local.lb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnets

  enable_deletion_protection = false
}

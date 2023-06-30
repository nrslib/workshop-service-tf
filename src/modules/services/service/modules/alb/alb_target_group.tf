resource "aws_alb_target_group" "blue" {
  name        = local.tg1_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = 30
    interval            = 60
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_alb_target_group" "green" {
  name        = local.tg2_name
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = 30
    interval            = 60
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_alb_target_group" "api" {
  name        = local.tgapi_name
  port        = 8180
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.api_health_check_path
    protocol            = "HTTP"
    timeout             = 30
    interval            = 60
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}
resource "aws_alb_listener" "prod" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_alb_listener" "test" {
  load_balancer_arn = aws_alb.main.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}
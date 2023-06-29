resource "aws_lb" "nlb" {
  name               = local.nlb_name
  load_balancer_type = "network"
  subnets            = var.vpc.private_subnets
  internal           = true

  enable_cross_zone_load_balancing = true

  depends_on = [module.alb]
}

resource "aws_lb_target_group" "nlb" {
  name        = local.nlb_tg_name
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc.vpc_id

  depends_on = [module.alb]
}

resource "aws_lb_target_group_attachment" "nlb" {
  target_group_arn = aws_lb_target_group.nlb.arn
  target_id        = module.alb.aws_alb_arn
  port             = 80

  depends_on = [module.alb]
}

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb.arn
  }

  depends_on = [module.alb]
}
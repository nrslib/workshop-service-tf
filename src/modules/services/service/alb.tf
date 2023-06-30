module "alb" {
  source = "./modules/alb"

  prefix = var.prefix
  name   = var.application_name
  hash   = var.hash
  vpc_id = var.vpc.vpc_id

  internal              = var.alb_internal
  security_group_id     = var.alb_security_group_id
  subnets               = var.alb_internal ? var.vpc.private_subnets : var.vpc.public_subnets
  container_port        = var.backend_container_port
  health_check_path     = var.frontend_health_check_path
}
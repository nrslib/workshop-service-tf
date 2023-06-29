data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# Network
module "network" {
  source = "../network"

  prefix           = var.prefix
  application_name = var.application_name

  vpc_cidr                     = var.vpc_cidr
  azs                          = data.aws_availability_zones.available.names
  public_subnet_cidr_blocks    = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks   = var.private_subnet_cidr_blocks
  public_subnet_nat_cidr_block = var.public_subnet_nat_cidr_block

  enable_dns_hostnames = var.enable_dns_hostnames
}

# Datastore
module "mysql" {
  source = "../datastore/rds_mysql"

  prefix           = var.prefix
  application_name = var.application_name

  vpc_id              = module.network.vpc.vpc_id
  vpc_private_subnets = module.network.vpc.private_subnets
  vpc_public_subnets  = module.network.vpc.public_subnets

  db_name              = var.db_name
  db_username          = var.rds_info.db_username
  db_port              = var.db_port
  db_apply_immediately = var.rds_info.apply_immediately
  db_security_group_id = module.security_groups.db.id
}

# Security Group
module "security_groups" {
  source = "../security_groups"

  prefix                          = var.prefix
  application_name                = var.application_name
  vpc_id                          = module.network.vpc.vpc_id
  db_port                         = var.db_port
  service_backend_container_port  = var.services_service_backend_container_port
  service_frontend_container_port = var.services_service_frontend_container_port
}

# Service
module "services_service" {
  source = "../services/service"

  prefix           = var.prefix
  application_name = var.application_name
  hash             = local.hash

  aws_region_name = data.aws_region.current.name
  aws_account_id  = var.aws_account_id

  vpc                   = module.network.vpc
  ecs_cluster_id        = module.network.ecs_cluster_id
  ecs_cluster_name      = module.network.ecs_cluster_name
  security_group_id     = module.security_groups.service.id
  alb_internal          = var.services_alb_internal
  alb_security_group_id = module.security_groups.service_alb.id
  need_vpc_link         = var.need_vpc_link

  backend_container_port     = var.services_service_backend_container_port
  backend_health_check_path  = var.services_service_backend_health_check_path
  frontend_container_port    = var.services_service_frontend_container_port
  frontend_health_check_path = var.services_service_frontend_health_check_path

  profile_active = var.profile_active

  db_name        = var.db_name
  db_secrets_arn = module.mysql.secrets_arn
}
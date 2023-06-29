locals {
  service_name            = var.application_name
  ecs_service_name        = "${var.prefix}-ecs-service-${local.service_name}"
  frontend_container_name = "${local.service_name}-frontend"
  backend_container_name  = "${local.service_name}-backend"

  nlb_complete_name = "${var.prefix}-nlb-${local.service_name}"
  nlb_shorten_name  = substr(local.nlb_complete_name, 0, 22)
  nlb_name          = "${local.nlb_shorten_name}${substr(var.hash, 0, 10)}"

  nlb_tg_complete_name = "${var.prefix}-nlbtg-${local.service_name}"
  nlb_tg_shorten_name  = substr(local.nlb_tg_complete_name, 0, 22)
  nlb_tg_name          = "${local.nlb_tg_shorten_name}${substr(var.hash, 0, 10)}"
}

variable "prefix" {}
variable "application_name" {}
variable "hash" { type = string }

variable "aws_region_name" {}
variable "aws_account_id" {}

variable "vpc" {
  type = object({
    vpc_id : string,
    private_subnets : list(string),
    public_subnets : list(string),
  })
}
variable "ecs_cluster_id" {}
variable "ecs_cluster_name" {}
variable "security_group_id" {}
variable "alb_internal" { type = bool }
variable "alb_security_group_id" {}
variable "need_vpc_link" { type = bool }

variable "backend_container_port" {}
variable "backend_health_check_path" {}
variable "frontend_container_port" {}
variable "frontend_health_check_path" {}
variable "profile_active" {}

variable "db_name" {}
variable "db_secrets_arn" {}

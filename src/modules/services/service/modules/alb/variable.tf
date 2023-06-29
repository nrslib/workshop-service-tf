locals {
  lb_complete_name = "${var.prefix}-alb-${var.name}"
  lb_shorten_name  = substr(local.lb_complete_name, 0, 22)
  lb_name          = "${local.lb_shorten_name}${substr(var.hash, 0, 10)}"

  tg1_complete_name = "${var.prefix}-albtg1-${var.name}"
  tg1_shorten_name  = substr(local.tg1_complete_name, 0, 22)
  tg1_name          = "${local.tg1_shorten_name}${substr(var.hash, 0, 10)}"

  tg2_complete_name = "${var.prefix}-albtg2-${var.name}"
  tg2_shorten_name  = substr(local.tg2_complete_name, 0, 22)
  tg2_name          = "${local.tg2_shorten_name}${substr(var.hash, 0, 10)}"

  tgapi_complete_name = "${var.prefix}-albapi-${var.name}"
  tgapi_shorten_name  = substr(local.tgapi_complete_name, 0, 22)
  tgapi_name          = "${local.tgapi_shorten_name}${substr(var.hash, 0, 10)}"
}

variable "prefix" {
  description = "the name of prefix"
}

variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}
variable "hash" { type = string }

variable "vpc_id" { description = "the vpc id" }
variable "internal" { type = bool }
variable "security_group_id" {}
variable "subnets" {
  type = list(string)
}
variable "container_port" {}
variable "health_check_path" {}
variable "api_health_check_path" {}
variable "api_port" {}
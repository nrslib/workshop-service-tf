locals {
  application_name = "${var.prefix}-${var.application_name}"
}

variable "prefix" { description = "the name of prefix" }
variable "application_name" {}
variable "vpc_id" { description = "the vpc id" }

variable "db_port" {}
variable "service_backend_container_port" {}
variable "service_frontend_container_port" {}
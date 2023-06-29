locals {
  should_create_nat_subnet = var.public_subnet_nat_cidr_block != null
}

variable "prefix" {}
variable "application_name" {}

variable "vpc_cidr" {}
variable "azs" {}
variable "public_subnet_cidr_blocks" { type = list(string) }
variable "private_subnet_cidr_blocks" { type = list(string) }
variable "public_subnet_nat_cidr_block" {
  type    = string
  default = null
}
variable "attach_vpn" {
  type    = bool
  default = false
}
variable "transit_gateway_id_vpn" { default = "tgw-01444eeca374161fe" }
variable "enable_dns_hostnames" {}
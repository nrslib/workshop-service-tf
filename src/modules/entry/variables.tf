locals {
  out_directory = "../../../out/${var.prefix}"
  hash_src      = "${var.aws_account_id}-${var.prefix}-${var.application_name}"
  hash          = replace(replace(lower(base64sha256(local.hash_src)), "+", "p"), "/", "s")

  # For hits.yaml
  service_ecr_name               = module.services_service.ecr_name
  ecr_host                       = "${var.aws_account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
}

# Basic
variable "aws_account_id" {}
variable "prefix" {}
variable "application_name" {}
variable "aws_profile" { default = "" }
variable "aws_region" { default = "ap-northeast-1" }
variable "owner" {}
variable "no_output" { default = true }

# Network
variable "need_vpc_link" { default = true }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}
variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24"
  ]
}
variable "public_subnet_nat_cidr_block" {
  description = "null: Create redundancy NAT Gateway (high cost)."
  default     = "10.0.6.0/24"
}
variable "enable_dns_hostnames" {}

# Data Store
variable "rds_info" {
  description = <<EOS
  db_name: must begin with a letter and contain only alphanumeric characters.
EOS
  type        = object({
    db_username : string,
    apply_immediately : bool
  })
  default     = null
}
variable "db_name" { default = "wsdb" }
variable "db_port" { default = "3306" }
variable "db_secret_arn" { default = null }

# Service
variable "services_alb_internal" { type = bool }
variable "profile_active" {}
variable "services_service_backend_container_port" {
  default = 8180
}
variable "services_service_frontend_container_port" {
  default = 3000
}
variable "services_service_backend_health_check_path" {
  default = "/actuator/health"
}
variable "services_service_frontend_health_check_path" {
  default = "/"
}

## 踏み台サーバー
variable "jump_server_enabled" {
  default     = true
  type        = bool
}
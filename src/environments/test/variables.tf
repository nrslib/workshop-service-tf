variable "aws_profile" { default = null }
variable "aws_region" { default = "ap-northeast-1" }

# Basic
variable "prefix" { default = "test" }
variable "application_name" { default = "workshop-service" }
variable "owner" { default = "test" }
variable "no_output" { default = true }

# Network
variable "enable_dns_hostnames" { default = true }
variable "need_vpc_link" { default = false }

# Data Store
variable "rds_info" {
  description = "db_name must begin with a letter and contain only alphanumeric characters."
  type        = object({
    db_username : string,
    apply_immediately : bool,
    jump_server_ami : map(string)
  })
  default     = {
    db_username : "ws_user",
    apply_immediately : true,
    jump_server_ami : {
      "ap-northeast-1" : "ami-0bba69335379e17f8"
    }
  }
}

# Service
variable "profile_active" { default = "test" }
variable "alb_internal" { default = false }
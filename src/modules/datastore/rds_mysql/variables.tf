variable "prefix" {}
variable "application_name" {}

variable "db_name" {}
variable "db_username" {}
variable "db_apply_immediately" {}
variable "db_port" { default = 3306 }
variable "db_security_group_id" {}

variable "vpc_id" {}
variable "vpc_private_subnets" {}
variable "vpc_public_subnets" {}

variable "engine" { default = "mysql" }
variable "engine_version" { default = "8.0.28" }
variable "major_engine_version" { default = "8.0" }
variable "family" { default = "mysql8.0" }
variable "db_instance" { default = "db.t3.small" }
variable "publicly_accessible" { default = false }
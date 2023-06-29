terraform {
  backend "s3" {
  }
}

data "aws_caller_identity" "self" {}

module "entry" {
  source = "../../modules/entry"

  aws_account_id = data.aws_caller_identity.self.account_id
  aws_profile    = var.aws_profile
  aws_region     = var.aws_region

  prefix               = var.prefix
  application_name     = var.application_name
  owner                = var.owner
  no_output            = var.no_output
  enable_dns_hostnames = var.enable_dns_hostnames
  need_vpc_link        = var.need_vpc_link
  rds_info             = var.rds_info

  profile_active        = var.profile_active
  services_alb_internal = var.alb_internal
}
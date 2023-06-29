provider "aws" {
  profile = var.aws_profile == "" ? null : var.aws_profile
  region  = var.aws_region

  default_tags {
    tags = {
      Environment     = var.prefix
      Owner           = var.owner
      ApplicationName = var.application_name
      HashSrc         = local.hash_src
      Hash            = local.hash
    }
  }
}
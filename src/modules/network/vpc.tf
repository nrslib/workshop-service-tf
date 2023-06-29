resource "aws_vpc" "_" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-vpc-${var.application_name}"
  }
}

resource "aws_internet_gateway" "_" {
  vpc_id = aws_vpc._.id
}

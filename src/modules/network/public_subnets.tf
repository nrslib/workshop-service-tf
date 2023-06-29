resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id            = aws_vpc._.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.prefix}-vpc-${var.application_name}-public-${count.index}"
  }
}

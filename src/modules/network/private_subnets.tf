resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc._.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.prefix}-vpc-${var.application_name}-private-${count.index}"
  }
}
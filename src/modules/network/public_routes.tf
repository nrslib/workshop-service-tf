resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc._.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway._.id
  }

  tags = {
    Name = "${var.prefix}-route-${var.application_name}-public"
  }
}

resource "aws_route_table_association" "public_subnets" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_subnets.id
}
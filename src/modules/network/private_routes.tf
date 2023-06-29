resource "aws_route_table" "private_subnet_routes" {
  count = length(aws_subnet.private_subnets)

  vpc_id = aws_vpc._.id

  tags = {
    Name = "${var.prefix}-route-${var.application_name}-private-${count.index}"
  }
}

resource "aws_route_table_association" "private_subnets" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_subnet_routes[count.index].id
}

resource "aws_route" "private_nat" {
  count = length(aws_subnet.private_subnets)

  route_table_id         = aws_route_table.private_subnet_routes[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.redundancy_nat_gateways[count.index].id
}
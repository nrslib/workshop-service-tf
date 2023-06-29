# Redundancy subnet
resource "aws_eip" "redundancy_nat_gateways" {
  count = length(aws_subnet.public_subnets)

  domain = "vpc"

  tags = {
    Name = "${var.prefix}-vpc-${var.application_name}-nat-${count.index}"
  }
}

resource "aws_nat_gateway" "redundancy_nat_gateways" {
  count = length(aws_subnet.public_subnets)

  subnet_id     = aws_subnet.public_subnets[count.index].id
  allocation_id = aws_eip.redundancy_nat_gateways[count.index].id

  tags = {
    Name = "${var.prefix}-nat-${var.application_name}-${count.index}"
  }
}

resource "aws_route_table_association" "redundancy_nat_gateways" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_subnets.id
}
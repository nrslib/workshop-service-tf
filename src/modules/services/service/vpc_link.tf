resource "aws_api_gateway_vpc_link" "_" {
  count = var.need_vpc_link ? 1 : 0

  name        = "${var.prefix}-vpclink-${local.service_name}"
  target_arns = [aws_lb.nlb.arn]
}
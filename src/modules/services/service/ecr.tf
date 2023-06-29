resource "aws_ecr_repository" "backend" {
  name = "${var.prefix}-ecr-${local.service_name}-backend"

  force_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.prefix}-ecr-${local.service_name}"
  }
}

resource "aws_ecr_repository" "frontend" {
  name = "${var.prefix}-ecr-${local.service_name}-frontend"

  force_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.prefix}-ecr-${local.service_name}"
  }
}
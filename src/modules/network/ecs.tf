module "ecs" {
  source  = "registry.terraform.io/terraform-aws-modules/ecs/aws"
  version = "v3.5.0"

  name                               = "${var.prefix}-ecs-cluster-${var.application_name}"
  container_insights                 = true
  capacity_providers                 = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = "1"
    }
  ]
  tags                               = {
    Name = "${var.prefix}-ecs-cluster-${var.application_name}"
  }
}
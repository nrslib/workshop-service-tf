resource "aws_codedeploy_app" "service" {
  name             = "${var.prefix}-deploy-${local.service_name}"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "service" {
  app_name               = aws_codedeploy_app.service.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.prefix}-group-${local.service_name}"
  service_role_arn       = aws_iam_role.codedeploy_service_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = aws_ecs_service._.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [module.alb.aws_alb_listener_prod.arn]
      }

      test_traffic_route {
        listener_arns = [module.alb.aws_alb_listener_test.arn]
      }

      target_group {
        name = module.alb.aws_alb_target_group_blue.name
      }

      target_group {
        name = module.alb.aws_alb_target_group_green.name
      }
    }
  }
}
# ECS タスク定義
resource "aws_ecs_task_definition" "_" {
  family                   = "${var.prefix}-ecs-task-${local.service_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role._.arn
  execution_role_arn       = aws_iam_role._.arn
  cpu                      = "512"
  memory                   = "4096"
  container_definitions    = <<EOF
[
  {
    "name": "${local.backend_container_name}",
    "image": "${aws_ecr_repository.backend.repository_url}",
    "portMappings": [
      { "containerPort": ${var.backend_container_port}, "hostPort": ${var.backend_container_port}, "protocol": "tcp" }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/logs/${var.prefix}-${local.service_name}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "essential": true,
    "environment": [
      { "name": "APPLICATION_PREFIX", "value": "${var.prefix}" },
      { "name": "SPRING_DATASOURCE_DATABASE", "value": "${var.db_name}" },
      { "name": "SERVER_PORT", "value": "${var.backend_container_port}" },
      { "name": "SPRING_PROFILES_ACTIVE", "value": "${var.profile_active}" }
    ],
    "secrets": [
      { "name": "SPRING_DATASOURCE_USERNAME", "valueFrom": "${var.db_secrets_arn}:username::" },
      { "name": "SPRING_DATASOURCE_PASSWORD", "valueFrom": "${var.db_secrets_arn}:password::" },
      { "name": "SPRING_DATASOURCE_HOST", "valueFrom": "${var.db_secrets_arn}:host::"},
      { "name": "SPRING_DATASOURCE_PORT", "valueFrom": "${var.db_secrets_arn}:port::"}
    ]
  },
  {
    "name": "${local.frontend_container_name}",
    "image": "${aws_ecr_repository.frontend.repository_url}",
    "portMappings": [
      { "containerPort": ${var.frontend_container_port}, "hostPort": ${var.frontend_container_port}, "protocol": "tcp" }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/logs/${var.prefix}-${local.service_name}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "essential": true,
    "environment": [
      { "name": "REACT_APP_PROXY_HOST", "value": "http://localhost:8180" }
    ],
    "secrets": [
    ]
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "_" {
  name = "/ecs/logs/${var.prefix}-${local.service_name}"

  tags = {
    Name = "${var.prefix}-ecs-cluster-${var.application_name}"
  }
}


resource "aws_ecs_service" "_" {
  name            = local.ecs_service_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition._.arn
  desired_count   = 3

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = var.alb_internal ? var.vpc.private_subnets : var.vpc.public_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb.aws_alb_target_group_blue.id
    container_name   = local.frontend_container_name
    container_port   = var.frontend_container_port
  }

  load_balancer {
    target_group_arn = module.alb.aws_alb_target_group_api.id
    container_name = local.backend_container_name
    container_port = var.backend_container_port
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}

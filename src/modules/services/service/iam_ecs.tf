# IAM
resource "aws_iam_policy" "_" {
  name   = "${var.prefix}-task-policy-${local.service_name}"
  path   = "/"
  policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "cloudwatch:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "${var.db_secrets_arn}"
      ]
    },
    {
        "Sid": "AllowAllXRay",
        "Effect": "Allow",
        "Action": "xray:*",
        "Resource": "*"
    }
  ]
}
EOS
}

resource "aws_iam_role" "_" {
  name               = "${var.prefix}-ecs-role-${local.service_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "_" {
  role       = aws_iam_role._.name
  policy_arn = aws_iam_policy._.arn
}

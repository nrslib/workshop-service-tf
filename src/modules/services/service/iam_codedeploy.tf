resource "aws_iam_role" "codedeploy_service_role" {
  name               = "${var.prefix}-deploy-svc-${local.service_name}"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "codedeploy.amazonaws.com"
        },
        Effect : "Allow",
      }
    ]
  })
}

resource "aws_iam_role_policy" "codedeploy_service_role" {
  name   = "${var.prefix}-deploy-svc-${local.service_name}"
  role   = aws_iam_role.codedeploy_service_role.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*",
        Effect : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_service_role_1" {
  role       = aws_iam_role.codedeploy_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

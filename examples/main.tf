resource "aws_iam_role" "step_function_role" {
  name = "StepFunctionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "states.amazonaws.com" }
      Action    = "sts:AssumeRole"
      },
      {
        Effect    = "Allow",
        Principal = { Service = "events.amazonaws.com" },
        Action    = "sts:AssumeRole"
      },
      {
        Effect    = "Allow",
        Principal = { Service = "ecs.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "step_function_policy" {
  name = "StepFunctionPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecs:RunTask",
        "ecs:DescribeTasks",
        "iam:PassRole",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecs:StopTask",
        "events:PutTargets",
        "events:PutRule",
        "events:DescribeRule",
        "states:StartExecution",
        "logs:CreateLogDelivery",
        "logs:CreateLogStream",
        "logs:GetLogDelivery",
        "logs:UpdateLogDelivery",
        "logs:DeleteLogDelivery",
        "logs:ListLogDeliveries",
        "logs:PutLogEvents",
        "logs:PutResourcePolicy",
        "logs:DescribeResourcePolicies",
        "logs:DescribeLogGroups"
      ],
      "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "state_machine_attachment" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_policy.arn
}


module "step_function" {
  source = "../"

  ecs_task_name      = local.name
  ecs_cluster_name   = "production"
  subnet_ids         = local.subnet_ids
  security_group_ids = local.security_group_ids

  role_arn            = local.step_fucnction_role_arn
  schedule_expression = "rate(1 minute)"
  retry_attempts      = 1

}

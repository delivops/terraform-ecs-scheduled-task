data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${data.aws_ecs_cluster.ecs_cluster.cluster_name}_${var.ecs_task_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "cowsay"
      image = "docker/whalesayy"
      cpu   = 0

      command = ["cowsay", "Hello from ECS!"]

      essential = true

    }
  ])
  lifecycle {
    ignore_changes = [all]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.log_level != "OFF" ? 1 : 0
  name              = "/ecs/${data.aws_ecs_cluster.ecs_cluster.cluster_name}/${var.ecs_task_name}"
  retention_in_days = 30
}

resource "aws_sfn_state_machine" "ecs_state_machine" {
  name     = "${data.aws_ecs_cluster.ecs_cluster.cluster_name}_${var.ecs_task_name}"
  role_arn = var.role_arn
  definition = jsonencode({
    Comment        = "Run ECS/Fargate tasks",
    StartAt        = "RunTask",
    TimeoutSeconds = var.timeout_seconds,
    States = {
      RunTask = {
        Type     = "Task",
        Resource = "arn:aws:states:::ecs:runTask.sync",
        Parameters = {
          LaunchType     = "FARGATE",
          Cluster        = data.aws_ecs_cluster.ecs_cluster.arn,
          TaskDefinition = aws_ecs_task_definition.this.arn,
          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = var.subnet_ids,
              AssignPublicIp = "${var.assign_public_ip}" ? "ENABLED" : "DISABLED",
              SecurityGroups = var.security_group_ids
            }
          }
        },
        Retry = [{
          ErrorEquals     = ["States.TaskFailed"],
          IntervalSeconds = var.retry_interval_seconds,
          MaxAttempts     = var.retry_attempts,
          BackoffRate     = var.retry_backoff_rate
        }],
        End = true
      }
    }
  })

  dynamic "logging_configuration" {
    for_each = var.log_level != "OFF" ? [1] : []
    content {
      log_destination        = "${aws_cloudwatch_log_group.log_group[0].arn}:*"
      include_execution_data = true
      level                  = var.log_level
    }

  }

  type = var.type
  lifecycle {
    ignore_changes = [definition]
  }
}

resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "${data.aws_ecs_cluster.ecs_cluster.cluster_name}-${var.ecs_task_name}-schedule-rule"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "state_machine_target" {
  rule     = aws_cloudwatch_event_rule.schedule_rule.name
  arn      = aws_sfn_state_machine.ecs_state_machine.arn
  role_arn = var.role_arn
}

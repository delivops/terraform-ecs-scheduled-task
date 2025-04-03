![image info](logo.jpeg)

# terraform-ecs-scheduled-task

Terraform-ecs-scheduled-task is a Terraform module for setting up a schedule task on ecs.

# Features

- Creates a task definition from an image "CAWSAY".
- Creates an AWS Step Functions state machine to run ECS tasks.
- Attaches necessary IAM policies for PassRole, RunTask, and event rule execution.
- Defines retry logic for handling task failures.

# Resources Created

- Task definition: Creates a task definition from an image name.
- Step Functions State Machine: Executes ECS tasks on Fargate.
- IAM Policies and Roles: Grants permissions for Step Functions and CloudWatch Event Rules.
- CloudWatch Event Rule: Triggers Step Functions execution on a schedule.

# Usage

```python

################################################################################
# AWS STEP-FUNCTIONS
################################################################################

module "step_function" {
  source = "../"

  ecs_task_name       = local.name
  ecs_cluster_name   = "production"
  subnet_ids         = local.subnet_ids
  security_group_ids = local.security_group_ids

  role_arn            = local.step_fucnction_role_arn
  schedule_expression = "rate(1 minute)"

}

```

# License

This project is licensed under the MIT License.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.schedule_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.state_machine_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_sfn_state_machine.ecs_state_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether to assign a public IP to the task | `bool` | `false` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The ARN of the ECS cluster | `string` | n/a | yes |
| <a name="input_ecs_task_name"></a> [ecs\_task\_name](#input\_ecs\_task\_name) | The name of the ECS task definition | `string` | n/a | yes |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The log level for the state machine | `string` | `"ERROR"` | no |
| <a name="input_retry_attempts"></a> [retry\_attempts](#input\_retry\_attempts) | The number of attempts to retry the task | `number` | `3` | no |
| <a name="input_retry_backoff_rate"></a> [retry\_backoff\_rate](#input\_retry\_backoff\_rate) | The rate at which the interval increases | `number` | `2` | no |
| <a name="input_retry_interval_seconds"></a> [retry\_interval\_seconds](#input\_retry\_interval\_seconds) | The interval between retries in seconds | `number` | `10` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role for the Step Functions state machine | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The schedule expression for the CloudWatch Event Rule | `string` | `"rate(1 minute)"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the ECS task | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the ECS task will run | `list(string)` | n/a | yes |
| <a name="input_timeout_seconds"></a> [timeout\_seconds](#input\_timeout\_seconds) | The time out for the state machine | `number` | `600` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of the state machine | `string` | `"STANDARD"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

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

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                    | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_event_rule.schedule_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)            | resource |
| [aws_cloudwatch_event_target.state_machine_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                         | resource |
| [aws_sfn_state_machine.ecs_state_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine)                | resource |

## Inputs

| Name                                                                                                      | Description                                                    | Type                                                                                                                                                                                                                                                                              | Default                    | Required |
| --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- | :------: |
| <a name="input_assign_public_ip"></a> [assign_public_ip](#input_assign_public_ip)                         | Whether to assign a public IP to the task                      | `bool`                                                                                                                                                                                                                                                                            | `false`                    |    no    |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                                           | AWS region                                                     | `string`                                                                                                                                                                                                                                                                          | `"us-east-1"`              |    no    |
| <a name="input_container_dependencies"></a> [container_dependencies](#input_container_dependencies)       | Container dependencies                                         | <pre>list(object({<br/> containerName = string<br/> condition = string<br/> }))</pre>                                                                                                                                                                                             | `[]`                       |    no    |
| <a name="input_container_image"></a> [container_image](#input_container_image)                            | Docker image for the container                                 | `string`                                                                                                                                                                                                                                                                          | `"nginx:latest"`           |    no    |
| <a name="input_container_name"></a> [container_name](#input_container_name)                               | Name of the container                                          | `string`                                                                                                                                                                                                                                                                          | `"app"`                    |    no    |
| <a name="input_container_port"></a> [container_port](#input_container_port)                               | Container port to expose                                       | `number`                                                                                                                                                                                                                                                                          | `80`                       |    no    |
| <a name="input_cpu"></a> [cpu](#input_cpu)                                                                | CPU units for the task                                         | `number`                                                                                                                                                                                                                                                                          | `256`                      |    no    |
| <a name="input_ecs_cluster_name"></a> [ecs_cluster_arn](#input_ecs_cluster_arn)                           | The ARN of the ECS cluster                                     | `string`                                                                                                                                                                                                                                                                          | n/a                        |   yes    |
| <a name="input_environment_variables"></a> [environment_variables](#input_environment_variables)          | Environment variables for the container                        | <pre>list(object({<br/> name = string<br/> value = string<br/> }))</pre>                                                                                                                                                                                                          | `[]`                       |    no    |
| <a name="input_execution_role_arn"></a> [execution_role_arn](#input_execution_role_arn)                   | ARN of the execution role                                      | `string`                                                                                                                                                                                                                                                                          | n/a                        |   yes    |
| <a name="input_logs_enabled"></a> [logs_enabled](#input_logs_enabled)                                     | Whether to enable logging for the container                    | `bool`                                                                                                                                                                                                                                                                            | `true`                     |    no    |
| <a name="input_memory"></a> [memory](#input_memory)                                                       | Memory for the task in MiB                                     | `number`                                                                                                                                                                                                                                                                          | `512`                      |    no    |
| <a name="input_mount_points"></a> [mount_points](#input_mount_points)                                     | Mount points for the container                                 | <pre>list(object({<br/> sourceVolume = string<br/> containerPath = string<br/> readOnly = optional(bool, false)<br/> }))</pre>                                                                                                                                                    | `[]`                       |    no    |
| <a name="input_network_mode"></a> [network_mode](#input_network_mode)                                     | Docker network mode for the container                          | `string`                                                                                                                                                                                                                                                                          | `"awsvpc"`                 |    no    |
| <a name="input_retry_attempts"></a> [retry_attempts](#input_retry_attempts)                               | The number of attempts to retry the task                       | `number`                                                                                                                                                                                                                                                                          | `3`                        |    no    |
| <a name="input_retry_backoff_rate"></a> [retry_backoff_rate](#input_retry_backoff_rate)                   | The rate at which the interval increases                       | `number`                                                                                                                                                                                                                                                                          | `2`                        |    no    |
| <a name="input_retry_interval_seconds"></a> [retry_interval_seconds](#input_retry_interval_seconds)       | The interval between retries in seconds                        | `number`                                                                                                                                                                                                                                                                          | `10`                       |    no    |
| <a name="input_runtime_platform"></a> [runtime_platform](#input_runtime_platform)                         | Runtime platform configuration                                 | <pre>object({<br/> cpu_architecture = optional(string, "ARM64")<br/> operating_system_family = optional(string, "LINUX")<br/> })</pre>                                                                                                                                            | `{}`                       |    no    |
| <a name="input_schedule_expression"></a> [schedule_expression](#input_schedule_expression)                | The schedule expression for the CloudWatch Event Rule          | `string`                                                                                                                                                                                                                                                                          | `"rate(1 minute)"`         |    no    |
| <a name="input_secrets"></a> [secrets](#input_secrets)                                                    | Secrets to pass to the container                               | <pre>list(object({<br/> name = string<br/> valueFrom = string<br/> }))</pre>                                                                                                                                                                                                      | `[]`                       |    no    |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids)                   | List of security group IDs for the ECS task                    | `list(string)`                                                                                                                                                                                                                                                                    | n/a                        |   yes    |
| <a name="input_step_function_name"></a> [step_function_name](#input_step_function_name)                   | The name of the workflow                                       | `string`                                                                                                                                                                                                                                                                          | `"EcsFargateStateMachine"` |    no    |
| <a name="input_step_function_policy_arn"></a> [step_function_policy_arn](#input_step_function_policy_arn) | The ARN of the IAM policy for the Step Functions state machine | `string`                                                                                                                                                                                                                                                                          | n/a                        |   yes    |
| <a name="input_step_function_role_arn"></a> [step_function_role_arn](#input_step_function_role_arn)       | The ARN of the IAM role for the Step Functions state machine   | `string`                                                                                                                                                                                                                                                                          | n/a                        |   yes    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)                                           | List of subnet IDs where the ECS task will run                 | `list(string)`                                                                                                                                                                                                                                                                    | n/a                        |   yes    |
| <a name="input_task_role_arn"></a> [task_role_arn](#input_task_role_arn)                                  | ARN of the task role                                           | `string`                                                                                                                                                                                                                                                                          | `null`                     |    no    |
| <a name="input_timeout_seconds"></a> [timeout_seconds](#input_timeout_seconds)                            | The time out for the state machine                             | `number`                                                                                                                                                                                                                                                                          | `600`                      |    no    |
| <a name="input_volumes"></a> [volumes](#input_volumes)                                                    | Volumes to be used in the task definition                      | <pre>list(object({<br/> name = string<br/> host_path = optional(string)<br/> efs_volume_configuration = optional(object({<br/> file_system_id = string<br/> root_directory = optional(string, "/")<br/> transit_encryption = optional(string, "DISABLED")<br/> }))<br/> }))</pre> | `[]`                       |    no    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->

variable "ecs_task_name" {
  description = "The name of the ECS task definition"
  type        = string

}

variable "role_arn" {
  description = "The ARN of the IAM role for the Step Functions state machine"
  type        = string

}

variable "ecs_cluster_name" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the ECS task will run"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ECS task"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the task"
  type        = bool
  default     = false
}

####CONFIGURATION###########

variable "schedule_expression" {
  description = "The schedule expression for the CloudWatch Event Rule"
  type        = string
  default     = "rate(1 minute)"
}
variable "retry_attempts" {
  description = "The number of attempts to retry the task"
  type        = number
  default     = 3

}
variable "retry_interval_seconds" {
  description = "The interval between retries in seconds"
  type        = number
  default     = 10

}
variable "retry_backoff_rate" {
  description = "The rate at which the interval increases"
  type        = number
  default     = 2

}
variable "timeout_seconds" {
  description = "The time out for the state machine"
  type        = number
  default     = 600

}

variable "type" {
  description = "The type of the state machine"
  type        = string
  default     = "STANDARD"

}

variable "log_level" {
  description = "The log level for the state machine"
  type        = string
  default     = "ERROR"

}

variable "container_name" {
  description = "The container_name"
  type        = string
  default     = "app"

}

variable "project_name" {
  description = "Project or group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for web instances (one per AZ)"
  type        = list(string)
}

variable "launch_template_id" {
  description = "Launch template ID from web module"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version (number or \"$Latest\")"
  type        = string
  default     = "$Latest"
}

variable "target_group_arns" {
  description = "ALB target group ARNs to register instances with"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances (null to omit and use min_size behavior)"
  type        = number
  default     = null
}

variable "health_check_grace_period" {
  description = "Seconds to wait before health checks affect replacement"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Common tags propagated to instances"
  type        = map(string)
  default     = {}
}

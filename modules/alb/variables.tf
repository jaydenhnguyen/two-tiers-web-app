variable "project_name" {
  description = "Project or group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  type        = string
}

variable "health_check_path" {
  description = "Target group health check path"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  description = "Project or group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for bastion instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID for bastion instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for bastion instance"
  type        = string
}

variable "key_name" {
  description = "Optional EC2 key pair name"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  description = "Project or group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for web instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for web instances"
  type        = string
}

variable "web_security_group_id" {
  description = "Security group ID used by web instances"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name (from iam module) attached to web instances"
  type        = string
}

variable "public_key_name" {
  description = "Optional key pair name for SSH access"
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "S3 bucket that stores website assets"
  type        = string
}

variable "s3_image_key" {
  description = "S3 object key for the image shown on the web page"
  type        = string
}

variable "team_name" {
  description = "Team name shown on the webpage"
  type        = string
}

variable "team_members" {
  description = "Team members shown on the webpage"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

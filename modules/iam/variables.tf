variable "project_name" {
  description = "Project or group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket that web instances read website assets from"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

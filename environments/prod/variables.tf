variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "AZs matching subnet order"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ami_id" {
  description = "AMI ID used for web server and bastion instances"
  type        = string
  default     = "ami-02dfbd4ff395f2a1b"
}

variable "vpc_cidr" {
  description = "VPC CIDR for prod"
  type        = string
  default     = "10.250.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (/24 each, one per AZ)"
  type        = list(string)
  default     = ["10.250.0.0/24", "10.250.1.0/24", "10.250.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (/24 each, one per AZ)"
  type        = list(string)
  default     = ["10.250.10.0/24", "10.250.11.0/24", "10.250.12.0/24"]
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to the bastion"
  type        = list(string)
}

variable "image_bucket_name" {
  description = "S3 bucket storing website image assets"
  type        = string
}

variable "image_file_name" {
  description = "S3 object key for image copied to web servers"
  type        = string
}

variable "key_pair_name" {
  description = "EC2 key pair name used by web server and bastion instances"
  type        = string
}

variable "vm_instance_type" {
  description = "Web server instance type"
  type        = string
  default     = "t3.medium"
}

variable "server_min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 3
}

variable "server_max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 4
}

variable "server_desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 3
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
  default     = "t3.micro"
}
output "web_role_arn" {
  description = "IAM role ARN for web EC2 instances"
  value       = aws_iam_role.web.arn
}

output "web_instance_profile_name" {
  description = "IAM instance profile name for web launch template"
  value       = aws_iam_instance_profile.web.name
}

output "web_instance_profile_arn" {
  description = "IAM instance profile ARN for web EC2 instances"
  value       = aws_iam_instance_profile.web.arn
}

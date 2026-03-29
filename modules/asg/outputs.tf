output "autoscaling_group_name" {
  description = "Name of the web Auto Scaling group"
  value       = aws_autoscaling_group.web.name
}

output "autoscaling_group_arn" {
  description = "ARN of the web Auto Scaling group"
  value       = aws_autoscaling_group.web.arn
}

output "scale_out_policy_arn" {
  description = "ARN of the scale-out scaling policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of the scale-in scaling policy"
  value       = aws_autoscaling_policy.scale_in.arn
}

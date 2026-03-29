output "alb_security_group_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "web_security_group_id" {
  description = "Security group ID for the web servers"
  value       = aws_security_group.web.id
}

output "bastion_security_group_id" {
  description = "Security group ID for bastion host"
  value       = aws_security_group.bastion.id
}

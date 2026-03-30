output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "Web target group ARN"
  value       = aws_lb_target_group.web_server.arn
}

output "listener_arn" {
  description = "HTTP listener ARN"
  value       = aws_lb_listener.http.arn
}

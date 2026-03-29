output "launch_template_id" {
  description = "Launch template ID for web instances"
  value       = aws_launch_template.web.id
}

output "launch_template_latest_version" {
  description = "Latest launch template version"
  value       = aws_launch_template.web.latest_version
}

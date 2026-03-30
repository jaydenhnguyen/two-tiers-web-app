output "launch_template_id" {
  description = "Launch template ID for web instances"
  value       = aws_launch_template.web_server_LT.id
}

output "launch_template_latest_version" {
  description = "Latest launch template version"
  value       = aws_launch_template.web_server_LT.latest_version
}

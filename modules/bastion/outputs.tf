output "instance_id" {
  description = "Bastion instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Bastion public IP"
  value       = aws_instance.this.public_ip
}

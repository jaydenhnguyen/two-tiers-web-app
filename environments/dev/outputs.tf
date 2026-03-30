output "alb_dns_name" {
  description = "DNS name of the load balancer; open this URL to reach the static site"
  value       = module.alb.alb_dns_name
}

output "website_url" {
  description = "HTTP URL for the website behind the ALB"
  value       = "http://${module.alb.alb_dns_name}"
}

output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.network.vpc_id
}

output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = module.bastion.instance_id
}

output "bastion_public_ip" {
  description = "Public IP of bastion instance"
  value       = module.bastion.public_ip
}

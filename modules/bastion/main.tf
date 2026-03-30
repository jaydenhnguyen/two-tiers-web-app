locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-Bastion"
    Tier = "Bastion"
  })
}

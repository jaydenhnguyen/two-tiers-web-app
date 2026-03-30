locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-AlbSG"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-AlbSG"
  })
}

resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-BastionSG"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-BastionSG"
  })
}

resource "aws_security_group" "web_server" {
  name        = "${local.name_prefix}-WebServerSG"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-WebServerSG"
  })
}

resource "aws_security_group_rule" "alb_http_in" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from the internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_to_web_server_http" {
  type                         = "egress"
  security_group_id            = aws_security_group.alb.id
  description                  = "Allow HTTP from ALB to web server"
  from_port                    = 80
  to_port                      = 80
  protocol                     = "tcp"
  referenced_security_group_id = aws_security_group.web_server.id
}

resource "aws_security_group_rule" "bastion_ssh_in" {
  count             = length(var.allowed_ssh_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id
  description       = "Allow SSH to bastion from trusted CIDR blocks"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidr_blocks
}

resource "aws_security_group_rule" "bastion_to_web_server_ssh" {
  type                         = "egress"
  security_group_id            = aws_security_group.bastion.id
  description                  = "Allow SSH from bastion to web server"
  from_port                    = 22
  to_port                      = 22
  protocol                     = "tcp"
  referenced_security_group_id = aws_security_group.web_server.id
}

resource "aws_security_group_rule" "web_server_http_from_alb" {
  type                         = "ingress"
  security_group_id            = aws_security_group.web_server.id
  description                  = "Allow HTTP only from ALB security group"
  from_port                    = 80
  to_port                      = 80
  protocol                     = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "web_server_ssh_from_bastion" {
  type                         = "ingress"
  security_group_id            = aws_security_group.web_server.id
  description                  = "Allow SSH from bastion host only"
  from_port                    = 22
  to_port                      = 22
  protocol                     = "tcp"
  referenced_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "web_server_egress_all" {
  #trivy:ignore:AVD-AWS-0104
  type              = "egress"
  security_group_id = aws_security_group.web_server.id
  description       = "Allow outbound for updates, S3, and health checks"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

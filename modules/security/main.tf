locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-AlbSg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Allow HTTP from ALB to web tier"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-AlbSg"
  })
}

resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-BastionSg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH to bastion from trusted CIDR blocks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    description     = "Allow SSH from bastion to web tier"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-BastionSg"
  })
}

resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-WebSg"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP only from ALB security group"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "Allow SSH from bastion host only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #trivy:ignore:AVD-AWS-0104
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-WebSg"
  })
}

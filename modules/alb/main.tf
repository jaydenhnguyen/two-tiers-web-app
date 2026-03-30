locals {
  name_prefix       = "${var.project_name}-${var.environment}"
  name_for_elb      = replace(replace(local.name_prefix, "_", "-"), " ", "-")
  alb_name          = substr("${local.name_for_elb}-alb", 0, 32)
  target_group_name = substr("${local.name_for_elb}-tg", 0, 32)
}

resource "aws_lb" "this" {
  name                       = local.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true

  tags = merge(var.tags, {
    Name = local.alb_name
  })
}

resource "aws_lb_target_group" "web" {
  name        = local.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = var.health_check_path
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name = local.target_group_name
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

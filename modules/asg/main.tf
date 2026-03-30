locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_autoscaling_group" "web" {
  name                      = "${local.name_prefix}-WebAsg"
  vpc_zone_identifier       = var.private_subnet_ids
  min_size                  = var.instances_min_size
  max_size                  = var.instances_max_size
  desired_capacity          = var.instance_desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = 300

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  target_group_arns = var.target_group_arns

  dynamic "tag" {
    for_each = merge(var.tags, {
      Name = "${local.name_prefix}-WebAsg"
    })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${local.name_prefix}-ScaleOut"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${local.name_prefix}-ScaleIn"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${local.name_prefix}-CpuAbove10Pct"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Scale out when average CPU is above 10%"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-CpuAbove10Pct"
  })
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${local.name_prefix}-CpuBelow5Pct"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Scale in when average CPU is below 5%"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-CpuBelow5Pct"
  })
}

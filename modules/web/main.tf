locals {
  name_prefix  = "${var.project_name}-${var.environment}"
  members_line = length(var.team_members) > 0 ? join(", ", var.team_members) : "TBD"
}

resource "aws_launch_template" "web" {
  name_prefix            = "${local.name_prefix}-WebLt-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.public_key_name
  vpc_security_group_ids = [var.web_security_group_id]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    bucket_name = var.s3_bucket_name
    image_key   = var.s3_image_key
    team_name   = var.team_name
    members     = local.members_line
    environment = var.environment
  }))

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${local.name_prefix}-Web"
    })
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-WebLt"
  })
}

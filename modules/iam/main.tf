locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_read_policy" {
  statement {
    sid    = "AllowReadObjectsFromWebsiteBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }

  statement {
    sid    = "AllowListWebsiteBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}"
    ]
  }
}

resource "aws_iam_role" "web" {
  name               = "${local.name_prefix}-WebRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-WebRole"
  })
}

resource "aws_iam_policy" "web_s3_read" {
  name   = "${local.name_prefix}-WebS3ReadPolicy"
  policy = data.aws_iam_policy_document.s3_read_policy.json

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-WebS3ReadPolicy"
  })
}

resource "aws_iam_role_policy_attachment" "web_s3_read" {
  role       = aws_iam_role.web.name
  policy_arn = aws_iam_policy.web_s3_read.arn
}

resource "aws_iam_instance_profile" "web" {
  name = "${local.name_prefix}-WebInstanceProfile"
  role = aws_iam_role.web.name
}

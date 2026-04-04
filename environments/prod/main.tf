provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  environment = "prod"
  common_tags = merge(
    {
      Environment = local.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.additional_tags
  )
}

module "network" {
  source = "../../modules/network"

  project_name         = var.project_name
  environment          = local.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "../../modules/security"

  project_name            = var.project_name
  environment             = local.environment
  vpc_id                  = module.network.vpc_id
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
  tags                    = local.common_tags
}

# module "iam" {
#   source = "../../modules/iam"
#
#   project_name      = var.project_name
#   environment       = local.environment
#   image_bucket_name = var.image_bucket_name
#   tags              = local.common_tags
# }

module "alb" {
  source = "../../modules/alb"

  project_name          = var.project_name
  environment           = local.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  tags                  = local.common_tags
}

module "web_server" {
  source = "../../modules/web_server"

  project_name                 = var.project_name
  environment                  = local.environment
  ami_id                       = var.ami_id
  instance_type                = var.vm_instance_type
  web_server_security_group_id = module.security.web_server_security_group_id
  # instance_profile_name        = module.iam.web_instance_profile_name
  instance_profile_name = "LabInstanceProfile"
  public_key_name       = var.key_pair_name
  image_bucket_name     = var.image_bucket_name
  image_file_name       = var.image_file_name
  team_name             = var.team_name
  team_members          = var.team_members
  tags                  = local.common_tags
}

module "bastion" {
  source = "../../modules/bastion"

  project_name      = var.project_name
  environment       = local.environment
  ami_id            = var.ami_id
  instance_type     = var.bastion_instance_type
  subnet_id         = module.network.public_subnet_ids[0]
  security_group_id = module.security.bastion_security_group_id
  key_name          = var.key_pair_name
  tags              = local.common_tags
}

module "asg" {
  source = "../../modules/asg"

  project_name              = var.project_name
  environment               = local.environment
  private_subnet_ids        = module.network.private_subnet_ids
  launch_template_id        = module.web_server.launch_template_id
  target_group_arns         = [module.alb.target_group_arn]
  instances_min_size        = var.server_min_size
  instances_max_size        = var.server_max_size
  instance_desired_capacity = var.server_desired_capacity
  tags                      = local.common_tags
}

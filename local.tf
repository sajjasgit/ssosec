locals {
  vpc_name             = "${var.app_name}-${var.env}-vpc"
  public_subnet_name   = "${local.vpc_name}-psb"
  public_rt_name       = "${local.vpc_name}-prt"
  igw_name             = "${local.vpc_name}-igw"
  nacl_name            = "${local.vpc_name}-nacl"
  ecr_name             = "${local.vpc_name}-ecr"
  sg_name              = "${local.vpc_name}-sg"
  iam_ecr_role         = "${local.vpc_name}-ecr-role"
  iam_ecr_role_profile = "${local.vpc_name}-ecr-role-profile"
  iam_ecr_role_policy  = "${local.vpc_name}-ecr-role-policy"
  ssosec_nic           = "${local.vpc_name}-nic"
  availability_zone    = "${var.region}a"
  instance_name        = "${local.vpc_name}-inc"
  tags = {
    Owner       = "ssosec-admin"
    Environment = var.env
  }
}
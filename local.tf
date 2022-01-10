locals {
  prefix               = "${var.app_name}-${var.env}"
  network_name         = "${var.prefix}-vpc"
  subnet_name          = "${local.prefix}-psb"
  public_rt_name       = "${local.prefix}-prt"
  igw_name             = "${local.prefix}-igw"
  nacl_name            = "${local.prefix}-nacl"
  ecr_name             = "${local.prefix}-ecr"
  sg_name              = "${local.prefix}-sg"
  iam_ecr_role         = "${local.prefix}-ecr-role"
  iam_ecr_role_profile = "${local.prefix}-ecr-role-profile"
  iam_ecr_role_policy  = "${local.prefix}-ecr-role-policy"
  ssosec_nic           = "${local.prefix}-nic"
  availability_zone    = "${var.region}a"
  instance_name        = "${local.prefix}-inc"
  tags = {
    Owner       = "ssosec-admin"
    Environment = var.env
  }
}
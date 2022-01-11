locals {
  # common
  prefix        = "${var.app_name}-${var.env}"
  network_name  = "${local.prefix}-virtual-net"
  subnet_name   = "${local.prefix}-sb"
  instance_name = "${local.prefix}-inc"
  tags = {
    Owner       = "ssosec admin"
    Environment = var.env
    Project     = "SSOSEC"
  }

  # AWS
  route_table_name     = "${local.prefix}-rt"
  igw_name             = "${local.prefix}-igw"
  nacl_name            = "${local.prefix}-nacl"
  ecr_name             = "${local.prefix}-ecr"
  sg_name              = "${local.prefix}-sg"
  iam_ecr_role         = "${local.prefix}-ecr-role"
  iam_ecr_role_profile = "${local.prefix}-ecr-role-profile"
  iam_ecr_role_policy  = "${local.prefix}-ecr-role-policy"
  availability_zone    = "${var.aws_region}a"


  # Azure
  ssosec_nic           = "${local.prefix}-nic"
  rg_name              = "${local.prefix}-rg"
  storage_os_disk_name = "${local.prefix}-disk1"
}
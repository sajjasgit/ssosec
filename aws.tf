module "aws" {
  source        = "./AWS"
  network_cidr  = var.network_cidr
  subnet_cidr   = var.subnet_cidr
  region        = var.aws_region
  instance_type = var.instance_type
  keyname       = var.keyname
  prefix        = "${var.app_name}-${var.env}"
  ssh_location  = var.ssh_location
}
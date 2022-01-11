locals {
  # common
  prefix = "${var.app_name}-${var.env}"
  tags = {
    Owner       = "ssosec admin"
    Environment = var.env
    Project     = "SSOSEC"
  }
}
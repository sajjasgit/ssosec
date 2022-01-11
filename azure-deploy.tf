module "azure-deploy" {
  source        = "./Azure"
  instance_type = var.instance_type
  keyname       = var.keyname
  network_cidr  = var.network_cidr
  subnet_cidr   = var.subnet_cidr
  region        = var.azure_region
  vm_hostname   = var.vm_hostname
  vm_username   = var.vm_username
  prefix        = "${var.app_name}-${var.env}"
  public_key    = tls_private_key.this.public_key_openssh
}
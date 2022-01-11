resource "azurerm_resource_group" "ssosec_rg" {
  name     = "${var.prefix}-rg"
  location = var.azure_region

  tags = local.tags
}
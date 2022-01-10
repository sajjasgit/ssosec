resource "azurerm_resource_group" "ssosec_rg" {
  name     = local.rg_name
  location = var.azure_region

  tags {
    Owner = "ssosec admin"
  }
}
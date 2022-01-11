resource "azurerm_container_registry" "ssosec_acr" {
  name                = local.container_repo_name
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name
  retention_policy {
    days    = 10
    enabled = true
  }
}
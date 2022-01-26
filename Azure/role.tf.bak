data "azuread_client_config" "current" {}

resource "azuread_application" "ssosec_acr" {
  display_name = "ssosec_app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "ssosec_acr_sp" {
  application_id               = azuread_application.ssosec_acr.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "aks_sp_container_registry" {
  scope                = azurerm_resource_group.ssosec_rg.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.ssosec_acr_sp.object_id
}
resource "random_string" "vm_sp_secret" {
  length  = 32
  special = true
}

resource "time_rotating" "this" {
  rotation_days = 7
}

resource "azuread_application" "ssosec_vm_app" {
  # name         = "${var.prefix}-acr-app"
  display_name = "${var.prefix}-acr-app"
}

resource "azuread_service_principal" "ssosec_vm_sp" {
  application_id               = azuread_application.ssosec_vm_app.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "ssosec_vm_sp" {
  service_principal_id = azuread_service_principal.ssosec_vm_sp.id
  rotate_when_changed = {
    rotation = time_rotating.this.id
  }
}

resource "azuread_application_password" "ssosec_vm_sp" {
  application_object_id = azuread_application.ssosec_vm_app.id
  rotate_when_changed = {
    rotation = time_rotating.this.id
  }
}

resource "azurerm_role_assignment" "aks_sp_container_registry" {
  scope                = azurerm_linux_virtual_machine.ssosec_vm.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.ssosec_vm_sp.object_id
}
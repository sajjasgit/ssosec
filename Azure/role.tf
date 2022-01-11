resource "random_string" "vm_sp_secret" {
  length  = 32
  special = true
}

resource "azuread_application" "ssosec_vm_app" {
  name         = local.ad_app_name
  display_name = local.ad_app_name
}

resource "azuread_service_principal" "ssosec_vm_sp" {
  application_id               = azuread_application.ssosec_vm_app.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "ssosec_vm_sp" {
  service_principal_id = azuread_service_principal.ssosec_vm_sp.id
  value                = random_string.vm_sp_secret.result
  end_date_relative    = "8760h"

  lifecycle {
    ignore_changes = [
      value,
      end_date_relative
    ]
  }
}

resource "azuread_application_password" "ssosec_vm_sp" {
  application_object_id = azuread_application.ssosec_vm_app.id
  value                 = random_string.vm_sp_secret.result
  end_date_relative     = "8760h"

  lifecycle {
    ignore_changes = [
      value,
      end_date_relative
    ]
  }
}

resource "azurerm_role_assignment" "aks_sp_container_registry" {
  scope                = azurerm_linux_virtual_machine.ssosec_vm.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.ssosec_vm_sp.object_id
}
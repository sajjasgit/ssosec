output "acr_repo_url" {
  value = azurerm_container_registry.ssosec_acr.login_server
}

output "azure_vm_publicip" {
  value = azurerm_linux_virtual_machine.ssosec_vm.public_ip_address
}
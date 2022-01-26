output "acr_repo_url" {
  value = azurerm_container_registry.ssosec_acr.login_server
}

output "azure_vm_publicip" {
  value = azurerm_public_ip.ssosec_public_ip
}
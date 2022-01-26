resource "azurerm_linux_virtual_machine" "ssosec_vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.ssosec_rg.location
  resource_group_name   = azurerm_resource_group.ssosec_rg.name
  network_interface_ids = [azurerm_network_interface.ssosec_nic.id]
  user_data             = base64encode(templatefile("${path.module}/scripts/install_app.sh", { APP_ACR_REPO_URL = azurerm_container_registry.ssosec_acr.login_sever, REGION = var.region }))
  # delete_os_disk_on_termination    = true
  # delete_data_disks_on_termination = true
  size           = "Standard_B2s"
  admin_username = var.vm_username

  admin_ssh_key {
    username   = var.vm_username
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.tags
}
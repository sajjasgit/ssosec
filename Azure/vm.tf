resource "azurerm_linux_virtual_machine" "ssosec_vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.ssosec_rg.location
  resource_group_name   = azurerm_resource_group.ssosec_rg.name
  network_interface_ids = [azurerm_network_interface.ssosec_nic.id]
  # delete_os_disk_on_termination    = true
  # delete_data_disks_on_termination = true
  size           = "Standard_DS1_v2"
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
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = local.tags
}
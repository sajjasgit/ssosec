resource "azurerm_linux_virtual_machine" "ssosec_vm" {
  name                             = local.instance_name
  location                         = azurerm_resource_group.ssosec_rg.location
  resource_group_name              = azurerm_resource_group.ssosec_rg.name
  network_interface_ids            = [azurerm_network_interface.ssosec_nic.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  size                             = "Standard_F2"
  computer_name                    = var.vm_hostname
  admin_username                   = var.vm_username

  admin_ssh_key {
    username   = var.vm_username
    public_key = tls_private_key.this.public_key_openssh
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
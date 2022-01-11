resource "azurerm_virtual_machine" "ssosec_vm" {
  name                  = local.instance_name
  location              = azurerm_resource_group.ssosec_rg.location
  resource_group_name   = azurerm_resource_group.ssosec_rg.name
  network_interface_ids = [azurerm_network_interface.ssosec_nic.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = local.storage_os_disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_hostname
    admin_username = var.vm_username
    # admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.this.public_key_openssh
      path     = "/home/${var.vm_username}/.ssh/authorized_keys"
    }
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "example" {
  name                             = "example-machine"
  location                         = azurerm_resource_group.ssosec_rg.location
  resource_group_name              = azurerm_resource_group.ssosec_rg.name
  network_interface_ids            = [azurerm_network_interface.ssosec_nic.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  size                             = "Standard_F2"
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
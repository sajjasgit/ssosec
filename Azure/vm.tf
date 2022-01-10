resource "azurerm_virtual_machine" "ssosec_vm" {
  name                  = local.vm_name
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
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    Owner = "ssosec admin"
  }
}
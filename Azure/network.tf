resource "azurerm_virtual_network" "ssosec_vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.network_cidr]
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name
  tags                = local.tags
}

resource "azurerm_subnet" "ssosec_subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.ssosec_rg.name
  virtual_network_name = azurerm_virtual_network.ssosec_vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "ssosec_public_ip" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name
  allocation_method   = "Dynamic"

  tags = local.tags
}

resource "azurerm_network_interface" "ssosec_nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name

  ip_configuration {
    name                          = "${var.prefix}-nic-config"
    subnet_id                     = azurerm_subnet.ssosec_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ssosec_public_ip.ip_address
  }
}

resource "azurerm_network_security_group" "ssosec_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name

  tags = local.tags
}

resource "azurerm_network_security_rule" "testrules" {
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.ssosec_rg.name
  network_security_group_name = azurerm_network_security_group.ssosec_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.ssosec_subnet.id
  network_security_group_id = azurerm_network_security_group.ssosec_nsg.id
}

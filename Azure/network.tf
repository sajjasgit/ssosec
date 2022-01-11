resource "azurerm_virtual_network" "ssosec_vnet" {
  name                = local.network_name
  address_space       = [var.network_cidr]
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name
}

resource "azurerm_subnet" "ssosec-subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.ssosec_rg.name
  virtual_network_name = azurerm_virtual_network.ssosec_vnet.name
  address_prefix       = var.subnet_cidr
}

resource "azurerm_public_ip" "ssosec_public_ip" {
  name                = "acceptanceTestPublicIp1"
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name
  allocation_method   = "Dynamic"

  tags = {
    owner = "ssosec admin"
  }
}

resource "azurerm_network_interface" "ssosec_nic" {
  name                = local.nic_name
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name

  ip_configuration {
    name                          = local.nic_ip_config_name
    subnet_id                     = azurerm_subnet.ssosec-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.ssosec_public_ip.ip_address
  }
}

resource "azurerm_network_security_group" "ssosec-nsg" {
  name                = local.nsg_name
  location            = azurerm_resource_group.ssosec_rg.location
  resource_group_name = azurerm_resource_group.ssosec_rg.name

  security_rule = [
    {
        name                       = "allow SSH inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "22"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow HTTP inbound"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "80"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow HTTPS inbound"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "443"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow SSH outbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "22"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow HTTP outbound"
        priority                   = 101
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "80"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow HTTPS outbound"
        priority                   = 102
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "443"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  ]

  tags = {
    Owner = "ssosec admin"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.ssosec-subnet.id
  network_security_group_id = azurerm_network_security_group.ssosec-nsg.id
}
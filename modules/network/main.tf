# Virtual Networks created with meta-argument for_each from map
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  tags                = lookup(each.value, "tags", {})
}

# Flatten nested subnets map for subnets for_each
locals {
  subnets_flat = merge([
    for vnet_key, vnet_val in var.vnets : {
      for snet_key, snet_val in vnet_val.subnets : "${vnet_key}.${snet_key}" => {
        name                 = snet_val.name
        resource_group_name  = vnet_val.resource_group_name
        virtual_network_name = azurerm_virtual_network.vnet[vnet_key].name
        address_prefixes     = snet_val.address_prefixes
        vnet_key             = vnet_key
        snet_key             = snet_key
      }
    }
  ]...)
}

# Subnets created with meta-argument for_each
resource "azurerm_subnet" "subnet" {
  for_each             = local.subnets_flat
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
}

# Network Security Groups created with for_each
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.vnets
  name                = "${each.value.name}-nsg"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = lookup(each.value, "tags", {})
}

# Subnet to NSG association with for_each
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = local.subnets_flat
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.vnet_key].id
}

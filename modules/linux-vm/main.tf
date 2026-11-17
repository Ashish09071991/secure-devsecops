# Optional Public IPs created with meta-argument for_each
resource "azurerm_public_ip" "pip" {
  for_each            = { for k, v in var.vms : k => v if lookup(v, "enable_public_ip", false) }
  name                = "${each.value.name}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = lookup(each.value, "tags", {})
}

# Network Interfaces created with meta-argument for_each
resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = lookup(each.value, "enable_public_ip", false) ? azurerm_public_ip.pip[each.key].id : null
  }

  tags = lookup(each.value, "tags", {})
}

# DevSecOps Hardened Linux VMs created with meta-argument for_each
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vms
  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = lookup(each.value, "vm_size", "Standard_B2s")
  admin_username                  = lookup(each.value, "admin_username", "azureuser")
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]

  admin_ssh_key {
    username   = lookup(each.value, "admin_username", "azureuser")
    public_key = each.value.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = lookup(each.value, "os_disk_type", "Standard_LRS")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = lookup(each.value, "tags", {})
}

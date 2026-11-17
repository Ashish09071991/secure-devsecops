output "vnets" {
  description = "Map of created VNets"
  value       = azurerm_virtual_network.vnet
}

output "subnets" {
  description = "Map of created Subnets keyed by vnet_key.snet_key"
  value       = azurerm_subnet.subnet
}

output "nsgs" {
  description = "Map of created NSGs"
  value       = azurerm_network_security_group.nsg
}

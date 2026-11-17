output "vms" {
  description = "Map of created Virtual Machines"
  value       = azurerm_linux_virtual_machine.vm
}

output "nics" {
  description = "Map of created NICs"
  value       = azurerm_network_interface.nic
}

output "pips" {
  description = "Map of created Public IPs"
  value       = azurerm_public_ip.pip
}

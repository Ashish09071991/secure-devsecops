output "resource_groups" {
  description = "Created Resource Groups map"
  value       = module.rg.rgs
}

output "vnets" {
  description = "Created Virtual Networks map"
  value       = module.network.vnets
}

output "subnets" {
  description = "Created Subnets map"
  value       = module.network.subnets
}

output "keyvaults" {
  description = "Created Key Vaults map"
  value       = module.keyvault.keyvaults
}

output "vms" {
  description = "Created Linux VMs map"
  value       = module.linux_vm.vms
}

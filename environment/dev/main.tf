# ==============================================================================
# PARENT MODULE (DEV ENVIRONMENT)
# Calls all child modules using maps and for_each meta-arguments
# ==============================================================================

# 1. Resource Groups Child Module
module "rg" {
  source  = "../../modules/resource-group"
  rgnames = var.rgnames
}

# 2. Virtual Networks & Subnets Child Module
module "network" {
  source     = "../../modules/network"
  vnets      = var.vnets
  depends_on = [module.rg]
}

# 3. Key Vaults Child Module (DevSecOps)
module "keyvault" {
  source     = "../../modules/keyvault"
  keyvaults  = var.keyvaults
  depends_on = [module.rg]
}

# 4. Linux Virtual Machines Child Module
# Injects the dynamic subnet_id output from module.network for each VM in the map
module "linux_vm" {
  source = "../../modules/linux-vm"
  vms = {
    for vm_key, vm_val in var.vms : vm_key => {
      name                 = vm_val.name
      resource_group_name  = vm_val.resource_group_name
      location             = vm_val.location
      subnet_id            = module.network.subnets[vm_val.subnet_key].id
      vm_size              = lookup(vm_val, "vm_size", "Standard_B2s")
      admin_username       = lookup(vm_val, "admin_username", "azureuser")
      admin_ssh_public_key = vm_val.admin_ssh_public_key
      enable_public_ip     = lookup(vm_val, "enable_public_ip", false)
      os_disk_type         = lookup(vm_val, "os_disk_type", "Standard_LRS")
      tags                 = lookup(vm_val, "tags", {})
    }
  }
  depends_on = [module.network]
}

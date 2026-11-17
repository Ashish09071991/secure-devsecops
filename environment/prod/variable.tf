# ==============================================================================
# VARIABLES (MAP DEFINITIONS FOR PROD ENVIRONMENT)
# ==============================================================================

variable "rgnames" {
  description = "Map of Resource Groups"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "vnets" {
  description = "Map of Virtual Networks and their Subnets"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = map(object({
      name             = string
      address_prefixes = list(string)
    }))
    tags = optional(map(string), {})
  }))
}

variable "keyvaults" {
  description = "Map of Azure Key Vaults"
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    sku_name                   = optional(string, "premium")
    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled   = optional(bool, true)
    enable_rbac_authorization  = optional(bool, true)
    tags                       = optional(map(string), {})
  }))
}

variable "vms" {
  description = "Map of Linux Virtual Machines"
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    subnet_key           = string
    vm_size              = optional(string, "Standard_D2s_v5")
    admin_username       = optional(string, "azureuser")
    admin_ssh_public_key = string
    enable_public_ip     = optional(bool, false)
    os_disk_type         = optional(string, "Premium_LRS")
    tags                 = optional(map(string), {})
  }))
}

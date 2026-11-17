variable "vms" {
  description = "Map of Linux Virtual Machines to create using meta-argument for_each"
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    subnet_id            = string
    vm_size              = optional(string, "Standard_B2s")
    admin_username       = optional(string, "azureuser")
    admin_ssh_public_key = string
    enable_public_ip     = optional(bool, false)
    os_disk_type         = optional(string, "Standard_LRS")
    tags                 = optional(map(string), {})
  }))
}

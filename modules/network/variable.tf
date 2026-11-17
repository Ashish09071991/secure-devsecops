variable "vnets" {
  description = "Map of Virtual Networks and their Subnets to create using meta-argument for_each"
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

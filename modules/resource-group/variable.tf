variable "rgnames" {
  description = "Map of Resource Groups to create using meta-argument for_each"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
}

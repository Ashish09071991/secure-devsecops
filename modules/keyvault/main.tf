data "azurerm_client_config" "current" {}

# Azure Key Vaults created with meta-argument for_each from map
resource "azurerm_key_vault" "kv" {
  for_each                    = var.keyvaults
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = lookup(each.value, "soft_delete_retention_days", 7)
  purge_protection_enabled    = lookup(each.value, "purge_protection_enabled", false)
  sku_name                    = lookup(each.value, "sku_name", "standard")
  enable_rbac_authorization   = lookup(each.value, "enable_rbac_authorization", true)
  tags                        = lookup(each.value, "tags", {})
}

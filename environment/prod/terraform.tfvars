# ==============================================================================
# PROD ENVIRONMENT TFVARS (MAP DATA STRUCTURES)
# ==============================================================================

# 1. Resource Groups Map
rgnames = {
  rg1 = {
    name     = "rg-devsecops-prod"
    location = "centralindia"
    tags = {
      Environment = "prod"
      Project     = "Secure-DevSecOps"
      ManagedBy   = "Terraform"
      Criticality = "Mission-Critical"
    }
  }
}

# 2. Virtual Networks & Subnets Map
vnets = {
  vnet1 = {
    name                = "vnet-devsecops-prod"
    resource_group_name = "rg-devsecops-prod"
    location            = "centralindia"
    address_space       = ["10.20.0.0/16"]
    subnets = {
      snet_web = {
        name             = "snet-web"
        address_prefixes = ["10.20.1.0/24"]
      }
      snet_app = {
        name             = "snet-app"
        address_prefixes = ["10.20.2.0/24"]
      }
      snet_db = {
        name             = "snet-db"
        address_prefixes = ["10.20.3.0/24"]
      }
    }
    tags = {
      Environment = "prod"
      Tier        = "Network"
    }
  }
}

# 3. Key Vaults Map (Prod Hardened)
keyvaults = {
  kv1 = {
    name                       = "kv-devsecops-prod-001"
    resource_group_name        = "rg-devsecops-prod"
    location                   = "centralindia"
    sku_name                   = "premium"
    soft_delete_retention_days = 90
    purge_protection_enabled   = true
    enable_rbac_authorization  = true
    tags = {
      Environment = "prod"
      Security    = "KeyVault"
    }
  }
}

# 4. Linux VMs Map (Prod Hardened: Standard_D2s_v5, Premium_LRS)
vms = {
  vm1 = {
    name                 = "vm-devsecops-prod"
    resource_group_name  = "rg-devsecops-prod"
    location             = "centralindia"
    subnet_key           = "vnet1.snet_app"
    vm_size              = "Standard_D2s_v5"
    admin_username       = "azureuser"
    admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGt7XDevSecOpsKeySampleNotForProdOnlyPlaceholder ashish@devops"
    enable_public_ip     = false
    os_disk_type         = "Premium_LRS"
    tags = {
      Environment = "prod"
      Role        = "Application"
    }
  }
}

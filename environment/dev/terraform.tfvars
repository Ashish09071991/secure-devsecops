# ==============================================================================
# DEV ENVIRONMENT TFVARS (MAP DATA STRUCTURES)
# ==============================================================================

# 1. Resource Groups Map
rgnames = {
  rg1 = {
    name     = "rg-devsecops-dev"
    location = "centralindia"
    tags = {
      Environment = "dev"
      Project     = "Secure-DevSecOps"
      ManagedBy   = "Terraform"
    }
  }
}

# 2. Virtual Networks & Subnets Map
vnets = {
  vnet1 = {
    name                = "vnet-devsecops-dev"
    resource_group_name = "rg-devsecops-dev"
    location            = "centralindia"
    address_space       = ["10.10.0.0/16"]
    subnets = {
      snet_web = {
        name             = "snet-web"
        address_prefixes = ["10.10.1.0/24"]
      }
      snet_app = {
        name             = "snet-app"
        address_prefixes = ["10.10.2.0/24"]
      }
      snet_db = {
        name             = "snet-db"
        address_prefixes = ["10.10.3.0/24"]
      }
    }
    tags = {
      Environment = "dev"
      Tier        = "Network"
    }
  }
}

# 3. Key Vaults Map
keyvaults = {
  kv1 = {
    name                       = "kv-devsecops-dev-001"
    resource_group_name        = "rg-devsecops-dev"
    location                   = "centralindia"
    sku_name                   = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    enable_rbac_authorization  = true
    tags = {
      Environment = "dev"
      Security    = "KeyVault"
    }
  }
}

# 4. Linux VMs Map
vms = {
  vm1 = {
    name                 = "vm-devsecops-dev"
    resource_group_name  = "rg-devsecops-dev"
    location             = "centralindia"
    subnet_key           = "vnet1.snet_app"
    vm_size              = "Standard_B2s"
    admin_username       = "azureuser"
    admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGt7XDevSecOpsKeySampleNotForProdOnlyPlaceholder ashish@devops"
    enable_public_ip     = false
    os_disk_type         = "Standard_LRS"
    tags = {
      Environment = "dev"
      Role        = "Application"
    }
  }
}

# Secure-DevSecOps Terraform Infrastructure

Production-ready, modular Terraform architecture implemented with parent-child modules, secure DevSecOps baselines, and dynamic environment folder selection.

---

## 📁 Directory Structure

```text
secure-devsecops/
├── modules/                               # 📦 CHILD MODULES (Reusable & Hardened)
│   ├── resource-group/                    # Child Module 1: Azure Resource Groups (for_each)
│   │   ├── main.tf, variable.tf, outputs.tf
│   ├── network/                           # Child Module 2: VNet, Subnets & NSG (SSH-only / Deny-All baseline)
│   │   ├── main.tf, variable.tf, outputs.tf
│   ├── keyvault/                          # Child Module 3: Azure Key Vault (RBAC, Soft-delete, Purge-protection)
│   │   ├── main.tf, variable.tf, outputs.tf
│   └── linux-vm/                          # Child Module 4: Hardened Ubuntu VM (SSH Key only, no plaintext passwords)
│       ├── main.tf, variable.tf, outputs.tf
│
├── environment/                           # 🏢 PARENT (ROOT) MODULES
│   ├── dev/                               # Dev Environment Folder
│   │   ├── provider.tf, main.tf, variable.tf, terraform.tfvars, outputs.tf
│   └── prod/                              # Prod Environment Folder
│       ├── provider.tf, main.tf, variable.tf, terraform.tfvars, outputs.tf
│
├── deploy.ps1                             # ⚡ Windows PowerShell Interactive Folder Selector
├── deploy.sh                              # ⚡ Linux/Mac/Git-Bash Interactive Folder Selector
└── README.md
```

---

## 🎯 Folder / Environment Select Karne Ke Options

### Option 1: Interactive PowerShell Script
Run in PowerShell:
```powershell
.\deploy.ps1
```
Yeh automatically `environment/` folder ko scan karega aur screen par `dev` / `prod` select karne ka menu show karega.

Non-interactive / Parameterised command:
```powershell
.\deploy.ps1 -Environment dev -Action plan
.\deploy.ps1 -Environment prod -Action plan
```

### Option 2: Terraform `-chdir` Flag
Bina directory change kiye root folder se direct kisi bhi environment ko target karein:
```bash
# Dev environment
terraform -chdir=environment/dev init
terraform -chdir=environment/dev plan

# Prod environment
terraform -chdir=environment/prod init
terraform -chdir=environment/prod plan
```

### Option 3: Direct `cd`
```bash
cd environment/dev
terraform init
terraform plan
```

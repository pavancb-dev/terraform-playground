# 📦 Feature 10: Modules

## ✅ What is a Module?
A module in Terraform is a container for multiple resources used together. Think of it as a reusable function in programming.

## 🧰 What Modules Are Used For
- Reuse infrastructure code
- Organize large configurations
- Share standard patterns across teams
- Build infrastructure as products (IaC-as-product)

## 🧱 Anatomy of a Terraform Module
A module typically contains:
- `main.tf` – resources and logic
- `variables.tf` – input variables
- `outputs.tf` – output values

## 📘 Types of Modules
| Type   | Example                                      |
|--------|----------------------------------------------|
| Local  | Stored in a subfolder of your current project|
| Remote | Pulled from GitHub, Terraform Registry, etc. |

## 📂 Example 1: Local Module
Build a reusable module to create a Resource Group.

**Folder Structure:**
```
terraform-project/
├── main.tf
├── modules/
│   └── resource_group/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

**modules/resource_group/main.tf**
```hcl
resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
```

**modules/resource_group/variables.tf**
```hcl
variable "name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags for the resource group"
  type        = map(string)
  default     = {}
}
```

**modules/resource_group/outputs.tf**
```hcl
output "id" {
  value = azurerm_resource_group.this.id
}

output "name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}
```

**main.tf (Root)**
```hcl
provider "azurerm" {
  features {}
}

module "demo_rg" {
  source   = "./modules/resource_group"
  name     = "demo-rg"
  location = "East US"
  tags = {
    Owner = "Pavan"
    Env   = "Dev"
  }
}

output "resource_group_id" {
  value = module.demo_rg.id
}
```

## 🌐 Example 2: Remote Module from Terraform Registry
Use a remote module from the Terraform Registry.

**main.tf**
```hcl
provider "azurerm" {
  features {}
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "5.0.1"
  resource_group_name = module.demo_rg.name
  vnet_location = module.demo_rg.location
}

output "vnet_id" {
  value = module.vnet.vnet_id
}
```
Explore this module: [Terraform Registry - Azure Vnet](https://registry.terraform.io/modules/Azure/vnet/azurerm/latest)

**Run the Project:**
```bash
terraform init
terraform apply
```

## 💡 Advanced Notes
### 🧩 Modules Can Be Nested
Modules can call other modules for deep reuse.

### 🔐 Modules Have Their Own State
Each module maintains its own state internally (especially with workspaces or backends).

## ✅ Best Practices
| Practice                          | Reason                                 |
|------------------------------------|----------------------------------------|
| Keep modules focused               | One job per module (e.g., only networking) |
| Use descriptive variable names     | Easier reuse                           |
| Use outputs meaningfully           | Let calling code get essential data    |
| Version remote modules             | Avoid breaking changes                 |
| Store custom modules in a shared repo | Consistency across teams           |

## ⚠️ Common Pitfalls
- Forgetting to pass required variables
- Trying to modify modules directly from the registry (use inputs instead)
- Using overly generic or bloated modules (keep them atomic)

## ✅ Summary Table
| Concept         | Description                       |
|-----------------|-----------------------------------|
| module block    | Calls a module with inputs        |
| source          | Path to local or remote module    |
| variables.tf    | Defines module inputs             |
| outputs.tf      | Exposes module values             |
| Local module    | source = "./modules/xyz"         |
| Remote module   | source = "org/module/provider"   |

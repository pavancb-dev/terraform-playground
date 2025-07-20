# 🧩 What are Local Values?

Local values are named expressions that let you define reusable values within a module or configuration file. They help:
- Avoid duplication
- Improve readability
- Simplify complex expressions

They are evaluated only once and cannot be changed during the execution of a plan or apply.

## 🔧 Syntax
```hcl
locals {
  environment = "dev"
  resource_prefix = "${local.environment}-app"
}
```
You can access these using `local.<name>`, like `local.resource_prefix`.

## 📘 Real-World Standalone Example (Azure Storage Account Naming)
Let’s say we want to generate a standardized name for an Azure Storage Account.

**main.tf:**
```hcl
provider "azurerm" {
  features {}
}

locals {
  environment      = "prod"
  location         = "eastus"
  business_unit    = "finance"
  resource_prefix  = "${local.business_unit}-${local.environment}-${local.location}"
  storage_name     = lower(replace(local.resource_prefix, "-", ""))
}

resource "azurerm_resource_group" "example" {
  name     = "${local.resource_prefix}-rg"
  location = local.location
}

resource "azurerm_storage_account" "example" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

**Result:**
- RG name: `finance-prod-eastus-rg`
- Storage account name: `financeprodeastus` (must be lowercase, no special chars)

## ✅ Use Cases
| Use Case              | Why Use locals?                |
|----------------------|--------------------------------|
| Reuse computed values| Don’t repeat long expressions   |
| Centralize logic     | Cleaner, easier to change      |
| Format names and tags| Standardize naming conventions |
| Intermediate calculations | Step-by-step processing of data |

## 💡 Best Practices
| Best Practice         | Explanation                    |
|----------------------|--------------------------------|
| Name locals clearly  | Use descriptive names like app_name, env_prefix, etc. |
| Group related logic  | Combine related locals in one locals block |
| Avoid excessive use  | Don’t overcomplicate with too many locals |
| Use for expressions, not config | Locals are for logic — not resource definitions |

## ⚠️ Common Pitfalls
| Pitfall                  | Impact                       |
|-------------------------|------------------------------|
| Using locals for everything | Makes code harder to trace/debug |
| Redefining values outside locals | Locals are read-only and immutable |
| Forgetting local. prefix | Causes undeclared identifier error |
| Using locals across modules | Not allowed — locals are module-scoped |

## 🧪 Quick Tip: Dynamic Tags with Locals
```hcl
locals {
  common_tags = {
    environment = "dev"
    owner       = "pavan"
    project     = "terraform-azure"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-tags"
  location = "eastus"
  tags     = local.common_tags
}
```

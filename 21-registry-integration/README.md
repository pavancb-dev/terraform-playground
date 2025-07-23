# 🌐 What is Terraform Registry Integration?

Terraform Registry Integration enables Terraform to:
- Download providers like azurerm, aws, google, etc.
- Fetch reusable modules published on the public Terraform Registry or private registries (like Terraform Cloud, GitHub, etc.)
- Automatically manage versioning and dependencies

## 🔎 Types of Integrations
| Integration Type | What You Get                                                      |
|------------------|-------------------------------------------------------------------|
| Provider         | Terraform knows how to talk to cloud APIs like Azure, AWS, etc.   |
| Module           | Prebuilt infrastructure-as-code (IaC) components (e.g., VPC module, Storage module) |
| Private Registry | Share custom modules inside your organization via Terraform Cloud or GitHub |

## ✅ Example 1: Using a Provider from the Registry
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```
Terraform will download this provider automatically. `source` tells where the provider is hosted (HashiCorp Registry).

## ✅ Example 2: Using a Module from the Public Registry
Suppose you want to create a VNet in Azure using a published module.

**main.tf:**
```hcl
module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "3.5.0"

  resource_group_name = "my-rg"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]

  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["subnet1", "subnet2"]
}
```
Terraform will download this module and use it just like any local module!
You can find it at: [registry.terraform.io/modules/Azure/vnet/azurerm](https://registry.terraform.io/modules/Azure/vnet/azurerm)

## ✅ Example 3: Using a Module from GitHub (Alternative Source)
```hcl
module "custom_module" {
  source = "github.com/your-org/terraform-azure-vm-module"
  vm_name = "myvm"
  ...
}
```

## ✅ Example 4: Private Module from Terraform Cloud
```hcl
module "my_secure_module" {
  source  = "app.terraform.io/my-org/my-vm/azurerm"
  version = "1.0.0"
}
```
Requires login to Terraform Cloud: `terraform login`

## 🔐 Authenticating to the Registry
If you're using Terraform Cloud private modules, authenticate using:
```bash
terraform login
```
This stores a CLI token in `~/.terraform.d/credentials.tfrc.json`.

## 🚀 Commands
| Command              | What It Does                                 |
|----------------------|----------------------------------------------|
| terraform init       | Downloads all providers and modules from the registry |
| terraform providers  | Lists all used providers and their sources    |
| terraform get        | Re-downloads modules (rarely needed with v1.1+) |

## 🧠 Best Practices
| Practice                        | Why                                 |
|----------------------------------|-------------------------------------|
| Pin module and provider versions | Ensures stability and reproducibility|
| Use trusted sources              | Avoid modules/providers from unknown/unverified orgs |
| Review module code before use    | Understand what you're deploying    |
| Prefer Terraform Registry over Git URLs | Better version control, metadata, and documentation |

## ⚠️ Common Pitfalls
| Pitfall                  | Issue                                    |
|-------------------------|-------------------------------------------|
| Not pinning module versions | Can break during future applies        |
| Forgetting terraform init   | Modules or providers won’t be fetched  |
| Using outdated modules      | Security or efficiency concerns        |
| Incorrect source strings    | Terraform won't be able to fetch the module |

## 📚 Resources
- Public Modules: https://registry.terraform.io/modules
- Public Providers: https://registry.terraform.io/providers
- Terraform Cloud: https://app.terraform.io

# Feature 3: Providers in Terraform

## 🌍 What are Providers?
Providers are plugins in Terraform that enable it to interact with external APIs and services, such as cloud platforms (Azure, AWS, GCP), SaaS tools (Datadog, GitHub), and infrastructure (Kubernetes, Docker). Providers expose the resources and data sources you can use in your configurations.

## 🧰 What are Providers Used For?
- Authenticating and configuring access to platforms (e.g., Azure)
- Exposing infrastructure objects you can define (e.g., azurerm_resource_group, aws_instance)
- Ensuring Terraform can create, read, update, and delete these objects

## 🧱 Structure of a Provider Block
```hcl
provider "azurerm" {
  features {}
}
```
- `azurerm` is the provider name (Azure Resource Manager)
- `features {}` is required for azurerm, even if empty
- Each provider may have its own configuration options (credentials, region, etc.)

## 🔐 Authentication with Azure Provider
There are three main ways to authenticate:
1. **Azure CLI** (easy for dev/test)
2. **Environment Variables** (great for CI/CD)
3. **Service Principal** (secure & recommended for automation)

### ✅ Using Azure CLI (Quickest for Local Setup)
```bash
az login
```
Terraform will pick up your credentials automatically.

### 🔐 Using a Service Principal (CI/CD or Production)
```bash
# One-time setup
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```
Then use environment variables or define them explicitly:
```hcl
provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "your-client-secret"
  tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

## 🔄 Multiple Providers / Aliases
You can define multiple configurations for the same provider using `alias`:
```hcl
provider "azurerm" {
  alias           = "east"
  features        = {}
  subscription_id = "sub-id-east"
  tenant_id       = "..."
}

provider "azurerm" {
  alias           = "west"
  features        = {}
  subscription_id = "sub-id-west"
  tenant_id       = "..."
}
```
Use the provider like:
```hcl
resource "azurerm_resource_group" "east_rg" {
  name     = "east-rg"
  location = "East US"
  provider = azurerm.east
}
```

## 🧪 Real-World Demo Context
So far in `main.tf`, we’re using:
```hcl
provider "azurerm" {
  features {}
}
```
If you ran `terraform init`, Terraform downloaded the azurerm plugin into the `.terraform` folder. That’s the provider plugin in action!

You can explicitly pin a provider version:
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }
}
```

## 💡 Best Practices
- Always pin provider versions using `required_providers`
- Use aliases when managing multiple accounts or regions
- Don’t hardcode credentials inside `.tf` files—use environment variables or secret managers

## ⚠️ Common Pitfalls
- Forgetting to run `terraform init` after changing provider settings
- Missing authentication config (especially in automation)
- Not pinning provider versions, leading to unexpected breaking changes
- Confusion with provider aliasing and usage across modules

## ✅ Recap
- Providers are essential for Terraform to interact with external systems
- We’ve been using the Azure provider (`azurerm`) behind the scenes
- You can authenticate via Azure CLI or a secure Service Principal setup

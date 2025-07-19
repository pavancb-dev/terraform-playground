# 🔍 Feature 8: Data Sources

## ✅ What is a Data Source?
A data source in Terraform lets you fetch information from existing infrastructure without managing it. It’s a read-only lookup for resources that:
- Already exist in your cloud provider
- Are created outside of Terraform
- Were created by other modules or teams

## 🧰 Use Cases
- Reference existing infrastructure (VMs, subnets, resource groups)
- Get dynamic/runtime information (latest AMI, existing network ID)
- Reduce hardcoding by fetching remote values
- Pass shared info across modules or environments

## 📘 Syntax
```hcl
data "<PROVIDER>_<RESOURCE_TYPE>" "<NAME>" {
  <arguments>
}
```

## 🧪 Example: Lookup Existing Resource Group in Azure
First, create the resource group in Azure using the CLI:

```sh
az group create --name existing_rg --location <location>
```
Replace `<location>` with your desired Azure region (e.g., `eastus`).

```hcl
data "azurerm_resource_group" "existing_rg" {
  name = "existing_rg"
}

output "rg_location" {
  value = data.azurerm_resource_group.existing_rg.location
}
```

## 🧪 Real-World Demo: Use Existing Resource Group’s Location
Suppose your Azure environment already has `demo-rg` and you want to create a storage account in the same location:
```hcl
data "azurerm_resource_group" "existing_rg" {
  name = "existing_rg"
}

resource "azurerm_storage_account" "storage" {
  name                     = "mystorageaccount123"
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  location                 = data.azurerm_resource_group.existing_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
Your code adapts automatically to wherever `existing_rg` is located.

## 🔎 Other Common Azure Data Sources

| Data Source Type      | Example                          |
|----------------------|----------------------------------|
| Resource Group       | `data "azurerm_resource_group"`  |
| Storage Account      | `data "azurerm_storage_account"` |
| Virtual Network      | `data "azurerm_virtual_network"` |
| Subnet               | `data "azurerm_subnet"`          |
| Key Vault Secrets    | `data "azurerm_key_vault_secret"`|

## 💡 Best Practices
- Use data sources instead of hardcoding values (like VNet IDs, locations).
- Prefer data sources when referencing shared or existing infrastructure.
- Use them in multi-team or modular setups for maximum reusability.

## ⚠️ Common Pitfalls
- Data sources are read-only; you cannot create resources with them.
- Referencing nonexistent resources will cause Terraform errors.
- Avoid using dynamic data in ways that violate immutability (e.g., choosing random resources).

## ✅ Recap
- Data sources let you read from existing cloud resources.
- Combine them with other resources to build context-aware infrastructure.
- They are great for shared infrastructure setups and reusability.

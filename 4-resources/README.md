# Feature 4: Resources in Terraform

## 🧱 What is a Resource?
A resource in Terraform represents a single infrastructure object in the provider’s API, such as:
- Azure Virtual Machine
- Storage Account
- Virtual Network
- Resource Group

Resources are what you create, update, and destroy with Terraform.

## 🧰 What are Resources Used For?
- Provisioning actual infrastructure (compute, networking, databases, etc.)
- Managing configuration state
- Declaratively defining infrastructure in `.tf` files

## 🔍 Structure of a Resource Block
```hcl
resource "<PROVIDER>_<RESOURCE_TYPE>" "<LOCAL_NAME>" {
  argument1 = value1
  argument2 = value2
}
```
**Example:**
```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = "demo-rg"
  location = "East US"
}
```
- `azurerm_resource_group` = resource type
- `demo_rg` = local name (used for referencing)
- `name`, `location` = configuration arguments

## 🔄 Referencing Resources
You can reference outputs from one resource in another using dot notation:
```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  address_space       = ["10.0.0.0/16"]
}
```
This creates inter-resource dependencies — Terraform uses these to build a dependency graph automatically.

## 🧪 Real-World Demo Update: Add Storage Account
Let's add an Azure Storage Account and connect it to our existing Resource Group.

**Append this to `main.tf`:**
```hcl
resource "azurerm_storage_account" "demo_storage" {
  name                     = "demostorage${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [azurerm_resource_group.demo_rg]
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
```
*Note: Azure requires globally unique storage account names — we use a random number to help.*

**Add to `outputs.tf`:**
```hcl
output "storage_account_name" {
  value = azurerm_storage_account.demo_storage.name
}
```

## 🏗 Your Terraform Dependency Graph Now Looks Like:
```
azurerm_resource_group.demo_rg
        ↓
azurerm_virtual_network.demo_vnet
        ↓
azurerm_subnet.demo_subnet
        ↓
azurerm_storage_account.demo_storage
```

## 💡 Best Practices
- Use meaningful resource names (e.g., "prod_db_rg" > "rg1")
- Reference values from other resources to reduce duplication
- Use `depends_on` only when absolutely necessary (Terraform handles most dependencies automatically)
- Group related resources in their own modules or files (e.g., `network.tf`, `compute.tf`)

## ⚠️ Common Pitfalls
- Not understanding how the dependency graph works — leads to ordering issues
- Naming conflicts (especially for global resources like Azure Storage Accounts)
- Forgetting to use `random_*` resources or unique suffixes where required
- Manual hardcoding of values that should be dynamically referenced

## ✅ Recap
- Resources are the building blocks of Terraform
- We added a real Azure Storage Account in our demo
- Resources can be linked together for dynamic, dependency-aware provisioning

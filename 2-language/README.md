# Feature 2: Terraform Configuration Language (HCL)

## 🌿 What is HCL?
HCL (HashiCorp Configuration Language) is the language used to write Terraform configurations. It's declarative: you describe what you want, and Terraform handles the rest. HCL is human-readable and structured, supporting:
- Blocks (resource, provider, variable, etc.)
- Expressions
- Functions
- Data types (string, number, list, map, etc.)

## 🧰 What is HCL Used For?
- Defining infrastructure resources
- Organizing reusable configurations
- Creating modules
- Passing variables and outputs
- Managing dependencies and conditions

## 🔍 Core HCL Syntax Breakdown

### 🔹 Blocks
```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = var.resource_group_name
  location = var.location
}
```
- **Type:** azurerm_resource_group
- **Name (local identifier):** demo_rg
- **Arguments:** name and location

### 🔹 Variables
```hcl
variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "demo_rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
```

### 🔹 Outputs
```hcl
output "location" {
  value = var.location
}
```

### 🔹 Expressions
```hcl
"${var.name}-env"
```

#### Functions
```hcl
upper(var.environment)
join("-", [var.prefix, var.environment])
```

## 🧪 Real-World Demo Update (Expanded HCL)
Let's expand our Terraform config with a virtual network (VNet) and a subnet inside the VNet.

### ✅ Updated main.tf
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "demo_vnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
}

resource "azurerm_subnet" "demo_subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.demo_rg.name
  virtual_network_name = azurerm_virtual_network.demo_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

### ✅ Updated outputs.tf
```hcl
output "vnet_name" {
  value = azurerm_virtual_network.demo_vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.demo_subnet.name
}
```

## 💡 Best Practices with HCL
- Use indentation and whitespace for readability
- Group related resources logically
- Use variables instead of hardcoded values
- Avoid long or overly nested expressions in-line—use local variables if needed
- Use descriptive names for resources and variables

## ⚠️ Common Pitfalls
- Using incorrect types (string vs list(string))
- Not quoting strings properly
- Forgetting to pass required variables
- Using interpolation (`${}`) unnecessarily in newer Terraform versions (it's now optional in many contexts)

## ✅ Recap
- HCL is the language used to define infrastructure in Terraform
- We used HCL to define a resource group, virtual network, and subnet
- HCL is clean, readable, and declarative

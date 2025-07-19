# Feature 5: Variables in Terraform

## 🔧 What are Variables?
Variables in Terraform allow you to parameterize your configuration, making your code reusable and customizable without hardcoding values.

## 🧰 What are Variables Used For?
- Making code reusable across environments (dev, staging, prod)
- Centralizing configuration values (region, resource names, tags)
- Avoiding duplication and hardcoding
- Supporting input from CLI, `.tfvars`, or environment variables

## 🧱 Types of Variables
Terraform supports multiple types:

| Type   | Example                                 |
|--------|-----------------------------------------|
| string | "East US"                               |
| number | 3, 2.5                                  |
| bool   | true, false                             |
| list   | ["web", "db", "cache"]                  |
| map    | { region = "East US", env = "dev" }     |
| object | { name = string, size = number }        |
| any    | Accepts any type                        |

## 🧪 How to Declare a Variable
Create a `variables.tf` file:
```hcl
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "demo-rg"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}
```

## 🛠 How to Use a Variable
Use `var.<variable_name>` syntax:
```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = var.resource_group_name
  location = var.location
}
```
All other resources referring to `azurerm_resource_group.demo_rg` automatically benefit from this.

## 📥 How to Pass Variables
- **Automatically:** When default is set
- **Manually using CLI:**
  ```bash
  terraform apply -var="location=West US"
  ```
- **Using a `.tfvars` file:**
  ```hcl
  # terraform.tfvars
  location = "West US"
  resource_group_name = "custom-rg"
  ```
  ```bash
  terraform apply -var-file="terraform.tfvars"
  ```
- **Environment variables:**
  ```bash
  export TF_VAR_location="West US"
  ```

## 🧪 Update Demo: Refactor Static Values into Variables
**Add `variables.tf`:**
```hcl
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "demo-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
```
**Modify `main.tf` Resource Group:**
```hcl
resource "azurerm_resource_group" "demo_rg" {
  name     = var.resource_group_name
  location = var.location
}
```

## 💡 Best Practices
- Always set `description` for variables — helps with documentation and module usage
- Use type validation for stricter and clearer code
- Use `.tfvars` for environment-specific overrides
- Keep `variables.tf`, `outputs.tf`, and `main.tf` organized separately

## ⚠️ Common Pitfalls
- Forgetting to assign a value to required variables (no default) will cause Terraform to prompt at runtime
- Using inconsistent naming or unclear variable names
- Not using types → leads to confusing error messages during plan/apply

## ✅ Recap
- Variables help make your Terraform code flexible and reusable
- You can define, use, and override them easily from many sources
- We updated our real-world demo to start using them already

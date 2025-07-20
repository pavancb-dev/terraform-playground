# 🧠 Expressions & Interpolation

## 🌱 What Are Expressions in Terraform?
Expressions are the building blocks of Terraform logic. They allow you to compute values dynamically using:
- Variables
- Resources
- Functions
- Conditionals
- Arithmetic
- String templates
- Collections (lists, maps, sets)

## 🧩 Interpolation (Legacy Style & Modern Style)
Interpolation refers to embedding expressions inside strings.

### ✅ Modern (Recommended) Style
```hcl
"Hello, ${var.name}"
```
Terraform will evaluate `${var.name}` and insert the value.

This is used only when mixing variables with strings. If the expression is the entire string, drop the quotes!
```hcl
name = var.name  # ✅ preferred
name = "${var.name}"  # ⚠️ discouraged unless part of a string
```

## 🔧 Expression Examples

### 📦 1. Variable Reference
```hcl
variable "env" {
  default = "dev"
}

resource "azurerm_resource_group" "example" {
  name     = "${var.env}-rg"
  location = "eastus"
}
```
✅ Interpolates "dev-rg"

### 🧮 2. Arithmetic
```hcl
locals {
  instance_count = 2 * 3
}
```
✅ Result: 6

### 🧪 3. Conditional (Ternary)
```hcl
locals {
  location = var.env == "prod" ? "centralus" : "eastus"
}
```
✅ Sets location based on environment

### 📚 4. Function Use Inside Interpolation
```hcl
output "upper_env" {
  value = upper(var.env)  # Converts to "DEV"
}
```

### 🔄 5. Combining Lists
```hcl
locals {
  zones = ["1", "2"]
  full_zones = [for z in local.zones : "zone-${z}"]
}
```
✅ Result: ["zone-1", "zone-2"]

## 🧠 Best Practices
| Best Practice                                 | Reason                                 |
|-----------------------------------------------|----------------------------------------|
| Use native expressions without interpolation  | Cleaner and faster                     |
| Avoid unnecessary quotes                      | "${var.name}" → just use var.name      |
| Use locals for complex expressions            | Improves readability and reuse         |
| Use interpolation only inside strings         | Otherwise, prefer native syntax        |

## ⚠️ Common Pitfalls
| Pitfall                        | Issue                                         |
|-------------------------------|-----------------------------------------------|
| Using interpolation in outputs when not needed | `output "x" { value = "${var.x}" }` is discouraged |
| Interpolating booleans or numbers             | "${true}" will become a string!        |
| Forgetting brackets                          | `${}` is required inside strings       |
| Using `${}` everywhere unnecessarily         | Avoids clarity and might cause Terraform warnings |

## ✅ Summary
| Expression Type      | Example                          |
|---------------------|----------------------------------|
| Variable            | var.name                         |
| Resource            | azurerm_rg.example.name          |
| Function            | lower("STRING")                  |
| Ternary             | condition ? true_val : false_val |
| List comprehension  | [for i in var.list : i.name]     |

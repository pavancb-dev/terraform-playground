# 🌱 What is a dynamic Block?

A dynamic block lets you programmatically generate nested blocks within a resource based on a list or map.

## 📌 Why Use It?
- When the number or content of nested blocks (like tags, settings, rules, etc.) depends on input
- Avoid repeating boilerplate for similar nested configurations

## 🔧 Structure of a dynamic Block
```hcl
dynamic "block_label" {
  for_each = <map or list>
  content {
    <block contents>
  }
}
```
- **block_label**: The name of the nested block (e.g., ingress, tag, setting)
- **for_each**: A list or map to loop over
- **content**: The actual configuration for each iteration

## ✅ Real-World Standalone Example (Azure Network Security Group Rules)
Let's create dynamic security rules inside an Azure NSG using dynamic blocks:

**main.tf:**
```hcl
variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-dynamic-demo"
  location            = "East US"
  resource_group_name = "your-existing-rg" # Replace with your RG

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

## 🧠 Best Practices
| Best Practice                        | Why                                 |
|--------------------------------------|-------------------------------------|
| Use dynamic only when needed         | Readability suffers if overused     |
| Always name for_each items like rule, tag, etc. | Makes code more understandable |
| Use structured input (list(object({...}))) | Enforces consistency         |
| Validate inputs with variable types  | Prevents invalid configurations at plan time |

## ⚠️ Common Pitfalls
| Pitfall                              | Impact                              |
|--------------------------------------|-------------------------------------|
| Using dynamic when for_each is enough| Over-complicates code               |
| Wrong type passed to for_each        | Causes runtime errors               |
| Forgetting to use .value in content  | Will cause undeclared identifier errors |
| Nesting dynamic inside dynamic       | Hard to read/debug                  |

## ✅ When To Use dynamic
- When nested blocks (like ingress, rule, settings, tag, etc.) vary in count or content
- To eliminate repetitive code when looping over complex nested configs
# 🧠 Terraform Functions

## ✅ What Are They?
Terraform provides a wide variety of built-in functions that let you transform and manipulate data dynamically during plan and apply. These functions operate on strings, collections, numbers, dates, conditionals, and more.

You can use functions inside expressions in your `.tf` files to compute values at runtime.

## 📚 Terraform Function Categories (with examples)
| Category         | Example Function      | Description                |
|------------------|----------------------|----------------------------|
| String           | join, replace        | Work with text             |
| Numeric          | min, max             | Work with numbers          |
| Collection       | length, merge        | Handle lists, maps, sets   |
| Encoding         | base64encode         | Encode/decode data         |
| Filesystem       | file, templatefile   | Read content from files    |
| Date & Time      | timestamp, formatdate| Work with dates            |
| Cryptographic    | md5, sha1            | Create hashes              |
| IP Network       | cidrsubnet           | Calculate subnets          |
| Type Conversion  | tostring, tonumber   | Convert types              |
| Conditional      | condition ? a : b    | Ternary expressions        |

## 🔧 Example 1: String + Collection Functions
```hcl
variable "env" {
  default = "dev"
}

locals {
  upper_env   = upper(var.env) # => "DEV"
  tag_keys    = ["team", "owner"]
  tag_values  = ["devops", "pavan"]
  merged_tags = zipmap(local.tag_keys, local.tag_values)
}

output "upper_env" {
  value = local.upper_env
}

output "merged_tags" {
  value = local.merged_tags
}
```

## 🔧 Example 2: Filesystem Function
```hcl
locals {
  file_content = file("${path.module}/welcome.txt")
}

output "readme" {
  value = local.file_content
}
```
`file()` reads the contents of a local file. Useful for injecting scripts or configs.

## 🔧 Example 3: Templating with `templatefile()`
**welcome.tpl**
```
Hello, ${name}!
Welcome to ${project}.
```
**main.tf**
```hcl
locals {
  rendered = templatefile("${path.module}/welcome.tpl", {
    name    = "Pavan"
    project = "Terraform Bootcamp"
  })
}

output "greeting" {
  value = local.rendered
}
```
Output: `Hello, Pavan! Welcome to Terraform Bootcamp.`

## 🔧 Example 4: Network Functions
```hcl
output "subnet" {
  value = cidrsubnet("10.0.0.0/16", 4, 2)
}
```
Breaks `10.0.0.0/16` into `/20` subnets and picks the third one (index 2): `10.0.32.0/20`

## 🧪 Advanced Use: Conditional + Type
```hcl
variable "is_production" {
  default = false
}

output "instance_type" {
  value = var.is_production ? "Standard_F4" : "Standard_B2"
}
```
Terraform will select instance size dynamically based on environment.

## ✅ Best Practices
| Tip                                   | Why                                 |
|----------------------------------------|-------------------------------------|
| Prefer locals + functions              | Keeps code clean and DRY            |
| Combine functions with templatefile()  | Makes large templates manageable    |
| Avoid excessive nesting                | Can get unreadable — break into locals|
| Use type conversion functions in conditionals | Prevent type mismatch issues |

## ⚠️ Common Pitfalls
- Passing string where a list is expected (use `split()`, `tolist()`)
- Forgetting quotes inside `templatefile()`
- Overusing functions in resource arguments — makes troubleshooting harder

## 📘 References
- [Terraform Functions Docs](https://developer.hashicorp.com/terraform/language/functions)

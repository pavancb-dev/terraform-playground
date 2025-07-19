# 🔄 Feature 9: lifecycle Block

## ✅ What is it?
The `lifecycle` block in Terraform gives you fine-grained control over how resources are created, updated, and deleted. Use it within a resource block to override default behaviors such as:
- Resource replacement during changes
- Preventing deletion
- Forcing recreation even when not strictly needed

## 🧰 Use Cases
- Avoid accidental destruction of critical infrastructure
- Control resource recreation behavior
- Manage immutable infrastructure patterns
- Prevent unnecessary updates on certain fields

## 🧪 Syntax Overview
```hcl
resource "azurerm_resource_group" "demo" {
  name     = "demo-rg"
  location = "East US"

  lifecycle {
    prevent_destroy      = true
    ignore_changes       = [tags]
    create_before_destroy = true
  }
}
```

## 📘 Lifecycle Arguments Explained

| Option                | What it Does                                                                 |
|-----------------------|------------------------------------------------------------------------------|
| `prevent_destroy`     | Prevents resource from being destroyed by `terraform destroy` or plan changes|
| `ignore_changes`      | Ignores updates to specified attributes (won’t trigger resource updates)     |
| `create_before_destroy`| Forces Terraform to create a new resource before destroying the old one      |

## 🧪 Example 1: `prevent_destroy`
```hcl
resource "azurerm_resource_group" "demo" {
  name     = "critical-rg"
  location = "East US"

  lifecycle {
    prevent_destroy = true
  }
}
```
If you run `terraform destroy`, Terraform will throw an error:
```
Error: Resource azurerm_resource_group.demo has prevent_destroy set, but a destroy was attempted.
```

## 🧪 Example 2: `ignore_changes`
Useful when another system or team updates a field you don't want Terraform to manage.
```hcl
resource "azurerm_storage_account" "storage" {
  name                     = "mydemoacct123"
  resource_group_name      = "demo-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [tags]
  }
}
```
Now if `tags` are changed manually or by a CI/CD tool, Terraform will not plan to revert them.

## 🧪 Example 3: `create_before_destroy`
Ideal when a resource must be replaced and you want to avoid downtime:
```hcl
resource "azurerm_storage_account" "storage" {
  name                     = "mydemoacct123"
  resource_group_name      = "demo-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    create_before_destroy = true
  }
}
```
⚠️ Only works for resources that support parallel creation (e.g., load balancers, VMs, disks). Not all resources allow this (e.g., globally unique names like storage accounts).

## 💡 Best Practices
- Use `prevent_destroy` for critical, stateful, or production resources (e.g., databases).
- Use `ignore_changes` for external config managers or tags applied outside Terraform.
- Use `create_before_destroy` when zero downtime is a must—be cautious with quotas or naming collisions.

## ⚠️ Common Pitfalls
- `ignore_changes` can lead to drift if overused.
- `create_before_destroy` may fail if naming constraints don’t allow duplicates.
- `prevent_destroy` can block legitimate destroy operations—use with intention.

## ✅ Recap

| You want to...           | Use this                |
|--------------------------|------------------------|
| Avoid deletion           | `prevent_destroy`      |
| Avoid unnecessary updates| `ignore_changes`       |
| Replace with zero downtime| `create_before_destroy`|

# Feature 6: Outputs in Terraform

## 📤 What are Outputs?
Outputs in Terraform allow you to display or expose values from your infrastructure after a successful `terraform apply`.

Think of outputs as a way to:
- View important results (like IPs, resource names, or credentials)
- Pass data between modules
- Help other tools or users consume Terraform-managed values

## 🧰 What are Outputs Used For?
- Printing key information after provisioning (e.g., public IP, connection strings)
- Passing resource attributes from child modules back to the parent module
- Debugging and validation of resource values

## 🧱 Basic Output Syntax
```hcl
output "<name>" {
  value       = <expression>
  description = "Optional description"
}
```

## 🧪 Example: Output Storage Account Name
```hcl
output "storage_account_name" {
  description = "The name of the Azure Storage Account"
  value       = azurerm_storage_account.demo_storage.name
}
```
When you run:
```bash
terraform apply
```
You’ll see:
```
Outputs:

storage_account_name = "demostorage12345"
```

## 🧪 Real-World Demo Enhancement: Add More Outputs
Update your `outputs.tf` file:
```hcl
output "resource_group_name" {
  value       = azurerm_resource_group.demo_rg.name
  description = "The name of the Resource Group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.demo_rg.location
  description = "Location of the Resource Group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.demo_storage.name
  description = "Name of the storage account"
}
```

## 🔁 Using Outputs Between Modules
If you use modules, you can reference outputs like this:
```hcl
module "networking" {
  source = "./modules/networking"
}

output "vnet_id" {
  value = module.networking.vnet_id
}
```
Modules are covered later, but just know that outputs help propagate values up.

## 💡 Best Practices
- Always provide a description for outputs — improves module clarity
- Only output what’s needed (don’t expose sensitive data unnecessarily)
- Use outputs to chain information between modules and automation scripts

## ⚠️ Common Pitfalls
- Forgetting to update `outputs.tf` when refactoring variables/resources
- Outputting sensitive data like passwords or keys accidentally
- Not using `sensitive = true` when needed, especially in CI logs

**Example:**
```hcl
output "admin_password" {
  value     = var.admin_password
  sensitive = true
}
```

## ✅ Recap
- Outputs help you expose useful info from your infrastructure
- We added outputs for resource group and storage account details
- You’ll see these values in CLI after each apply

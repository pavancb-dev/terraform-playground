# 🔄 Terraform Import

## 📌 What is terraform import?
Terraform’s import command brings existing cloud infrastructure under Terraform management without modifying it.

✅ This is extremely useful when:
- You’ve created resources manually via Azure Portal
- You’re migrating from ARM templates or scripts
- You want Terraform to manage legacy resources

## 🛠️ What Does It Do?
- Links a real-world resource (in Azure, AWS, etc.) to a Terraform resource block in your code
- Updates the `.tfstate` file with real resource data
- Does not auto-generate `.tf` configuration (you write it manually)

## 🧪 Real-World Azure Example
Say you created a Resource Group manually in Azure named `my-rg-import` in `eastus`.

### 🧾 Step 1: Write Resource Block (No Apply Yet)
```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-rg-import"
  location = "eastus"
}
```

### 🧾 Step 2: Run the Import Command
```bash
terraform import azurerm_resource_group.example /subscriptions/<subscription_id>/resourceGroups/my-rg-import
```
Replace `<subscription_id>` with your actual Azure subscription ID.

You can find the resource ID using:
```bash
az group show --name my-rg-import --query id --output tsv
```

## ✅ What Happens Next?
- Terraform will fetch the state of the real Azure resource
- It updates your `terraform.tfstate`
- Now Terraform manages the resource, even though it didn’t create it

## 🧠 Best Practices
| Practice                              | Reason                                 |
|----------------------------------------|----------------------------------------|
| Always write the Terraform resource block first | Terraform import doesn’t generate it for you |
| Import to an empty .tfstate if you're unsure    | Prevent conflicts                     |
| Use terraform plan after import        | Check if the configuration matches the real state |
| Document imported resources clearly    | Helps team members understand migration history |

## ⚠️ Common Pitfalls
| Pitfall                               | Problem                                |
|----------------------------------------|----------------------------------------|
| Running import before writing resource block | Error: No matching resource           |
| Not matching the config to actual resource values | Terraform will try to recreate/modify |
| Forgetting resource IDs                | Azure resource IDs are long and case-sensitive |
| Assuming it replaces terraform apply   | Import does NOT create or modify anything |

## 🧼 Undo an Import?
To remove the resource from Terraform state (but not delete from cloud):
```bash
terraform state rm azurerm_resource_group.example
```

> 🚨 **Pro Tip:** Use This With Caution
> terraform import is safe, but planning afterward is critical
> Run `terraform plan` immediately after to verify Terraform sees the resource as "up to date"
> If not, tweak your `.tf` config until no changes are detected

## 📁 Summary
| Step | Action                                      |
|------|---------------------------------------------|
| 1.   | Write the correct Terraform config manually  |
| 2.   | Run terraform import <address> <resource-id> |
| 3.   | Run terraform plan to confirm no changes     |
| 4.   | Commit both config and updated .tfstate      |

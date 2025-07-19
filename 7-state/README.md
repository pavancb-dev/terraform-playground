# Feature 7: State in Terraform

## 🧾 What is State?
Terraform uses a state file to keep track of:
- What resources it has created
- The current configuration of those resources
- The mapping between your `.tf` files and real infrastructure

This file is stored locally as `terraform.tfstate` by default.

## 🧰 What is State Used For?
- Tracks the infrastructure’s current state
- Enables Terraform to compare desired vs actual state and take action
- Determines what to add, change, or destroy
- Facilitates resource dependency tracking and output propagation

## 🔍 Where Does State Live?
- **Default:** `terraform.tfstate` (local)
- **Better:** Remote backends like Azure Storage, S3, Terraform Cloud, etc. (for collaboration and safety)

## 📁 Example: State File Structure (Simplified)
```json
{
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "demo_rg",
      "instances": [
        {
          "attributes": {
            "name": "demo-rg",
            "location": "East US"
            // ...
          }
        }
      ]
    }
  ]
}
```
Terraform never queries the cloud directly unless it compares against this file.

## 🛠️ Real-World Demo Tip
After you run:
```bash
terraform apply
```
You’ll see:
- `terraform.tfstate` (machine-readable)
- `terraform.tfstate.backup` (previous state)

## 🔄 Commands You Should Know
```bash
terraform state list           # List all tracked resources
terraform state show <name>    # Show full state of a resource
terraform refresh              # Sync state with real infra
terraform state rm <name>      # Remove resource from state
terraform import               # Import existing resource into state
```
**Example:**
```bash
terraform state show azurerm_resource_group.demo_rg
```

## ☁️ Enable Remote State (with Azure Storage)
Later in this series, we will:
- Create a storage account
- Create a container for storing state
- Configure Terraform backend like this:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "my-rg"
    storage_account_name  = "tfstatestorage123"
    container_name        = "tfstate"
    key                   = "prod.terraform.tfstate"
  }
}
```
This enables team collaboration, locking, and versioning.

## 💡 Best Practices
- Never manually edit the `terraform.tfstate` file
- Use remote state when collaborating across a team
- Enable state locking to prevent race conditions
- Use state outputs to pass values between modules/environments

## ⚠️ Common Pitfalls
- Deleting or corrupting the state file = Terraform "forgets" what it did
- Manual modification of state = unpredictable behavior
- Ignoring remote backend for teams = frequent merge conflicts
- Forgetting to version control your infrastructure but accidentally committing the tfstate file (**don’t do this**)

## ✅ Recap
- Terraform state is your single source of truth
- It enables planning, comparison, change tracking, and output visibility
- Managing and securing your state is critical for safe infrastructure automation

# Beginner Guide: Terraform on Azure

## 🔰 What is Terraform?
Terraform is an open-source Infrastructure as Code (IaC) tool by HashiCorp. It lets you define, provision, and manage infrastructure (VMs, networks, storage, etc.) using declarative configuration files written in HCL (HashiCorp Configuration Language).

## 🛠 Why Use Terraform?
- **Platform agnostic:** Works with AWS, Azure, GCP, and more
- **Reproducible, version-controlled infrastructure**
- **Automates complex cloud provisioning**
- **Supports modular, reusable code for scalability**

---
# 🚀 Terraform Commands

### ✅ What is it?
The Terraform CLI is the main way to interact with Terraform. It provides commands to:
- Initialize projects
- Validate configuration
- Generate execution plans
- Apply or destroy infrastructure
- Inspect and manage state

### 🧰 What it's used for
- Bootstrapping a new project (`terraform init`)
- Reviewing planned changes (`terraform plan`)
- Deploying infrastructure (`terraform apply`)
- Removing infrastructure (`terraform destroy`)
- Debugging and inspecting (`terraform show`, `terraform state`, etc.)

## 📦 Example Setup (Step-by-Step)
Let's create a working Terraform example on Azure using CLI commands.

### 📁 1. Folder Structure
```
01-commands/
├── main.tf
```

### 🧾 2. main.tf – Minimal Working Configuration
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_rg" {
  name     = "demo_rg"
  location = "eastus"
}
```

### 🧪 3. CLI Commands
Run these in your terminal inside the `terraform-azure-demo/` folder:

```bash
# Step 1: Initialize the working directory
terraform init

# Step 2: Preview what Terraform will do
terraform plan

# Step 3: Apply the infrastructure
terraform apply

# Step 4: Optionally destroy
terraform destroy
```

## 💡 Best Practices
- Always run `terraform plan` before `apply`
- Use `.terraform.lock.hcl` for dependency consistency
- Use CLI commands with `-out` and `-auto-approve` in automation
- Use CLI inside CI/CD pipelines for full automation

## ⚠️ Common Pitfalls
- Running `terraform apply` without checking `plan` first
- Forgetting to run `terraform init` when changing providers/modules
- Misconfiguring credentials for Azure CLI/authentication
- Deleting `.terraform` directory manually (removes initialized backend/plugins)
# 🧩 Terraform Workspaces

## ✅ What Are Workspaces?
A Terraform workspace is like a named instance of your Terraform state. Each workspace has its own separate state file, which allows you to:
- Reuse the same codebase across multiple environments (e.g., dev, stage, prod)
- Manage isolated infrastructure per environment without copying your code
- Avoid state file conflicts when managing multiple environments from a single directory

> 💡 Think of a workspace like a branch of state. The Terraform configuration files stay the same, but the infrastructure tracked (state) is different.

## 🏗️ Why Use Workspaces?
**Common Use Cases:**
| Use Case                | Benefit                      |
|-------------------------|------------------------------|
| dev, stage, prod envs   | Same code, isolated infra    |
| Multi-region infra      | Workspace per region         |
| Isolated sandbox testing| Play around without affecting other states |

## 🔧 How Workspaces Work
- Each workspace maintains its own state file (e.g., `terraform.tfstate.d/<workspace_name>/terraform.tfstate`)
- When you switch workspaces, Terraform uses the state tied to that workspace but runs the same config

## 🛠️ Workspace Commands
| Command                        | Description                |
|--------------------------------|----------------------------|
| terraform workspace list       | Show available workspaces  |
| terraform workspace show       | Show current workspace     |
| terraform workspace new <name> | Create a new workspace     |
| terraform workspace select <name>| Switch to a workspace    |
| terraform workspace delete <name>| Delete a workspace       |

## 🔁 Workspace Lifecycle Example
```bash
# Show current workspace (default)
terraform workspace show

# Create a new workspace
terraform workspace new dev

# Switch to another workspace
terraform workspace select dev

# List all workspaces
terraform workspace list
```

## 📁 Directory Structure (Automatic by Terraform)
Terraform stores state like this:
```
.
├── main.tf
├── terraform.tfstate.d/
│   ├── dev/
│   │   └── terraform.tfstate
│   ├── prod/
│   │   └── terraform.tfstate
```
Each directory represents a workspace's state.

## 🧪 Simple Example Using Workspaces
**main.tf**
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "workspace-rg-${terraform.workspace}"
  location = "East US"
}
```
`terraform.workspace` is a built-in function that returns the current workspace name.

So:
- In dev workspace: RG name will be `workspace-rg-dev`
- In prod workspace: RG name will be `workspace-rg-prod`

**Steps:**
```bash
terraform init

# Create dev workspace
terraform workspace new dev
terraform apply   # Creates 'workspace-rg-dev'

# Create prod workspace
terraform workspace new prod
terraform apply   # Creates 'workspace-rg-prod'
```
🎉 Same code, separate infrastructure!

## ✅ Best Practices
| Tip                                   | Why                                 |
|----------------------------------------|-------------------------------------|
| Use workspaces for environment isolation| Clean, DRY approach                 |
| Name workspaces clearly (dev, stage, prod)| Easy to manage                   |
| Use terraform.workspace in resource names| Avoid name collisions             |
| Combine with remote backends           | Enables cloud collaboration         |

## ⚠️ Common Pitfalls
| Mistake                                | Problem                            |
|-----------------------------------------|------------------------------------|
| Using workspaces for complex multi-module projects | Can become hard to manage |
| Forgetting which workspace you're in    | May apply to wrong env             |
| Using workspaces as a full substitute for directory-based isolation | Not always enough for complex pipelines |

## 🔄 Workspace vs Directory Strategy
| Approach      | Pros                | Cons                               |
|--------------|---------------------|------------------------------------|
| Workspaces    | DRY, clean, fast switching | Less visibility, limited pipeline support |
| Multiple folders (dev/, prod/)| Full isolation      | Code duplication                  |

👑 **Best practice in large teams:** combine both — use folders for drastically different configurations, and workspaces for variations.

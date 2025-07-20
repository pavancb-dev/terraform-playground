# ☁️ Remote Backends

## ✅ What Is a Remote Backend?
A backend in Terraform is where Terraform stores the state file. A remote backend means this state is stored outside your local machine, often in:
- Azure Storage Account
- AWS S3
- Google Cloud Storage
- Terraform Cloud / Enterprise
- Consul, etc.

## 🚀 Why Use a Remote Backend?
| Benefit              | Description                                 |
|----------------------|---------------------------------------------|
| ✅ Team Collaboration| Everyone sees the latest state              |
| 🔒 State Locking     | Prevents race conditions (e.g., Azure, S3 w/ DynamoDB) |
| 📦 Centralized State | Secure and auditable                        |
| 🧪 Consistent Applies| No risk of different local states           |
| 🔐 Access Control    | Integrate with cloud IAM                    |

## 🔍 How Does It Work?
When Terraform runs, it will:
- Authenticate with your cloud backend
- Fetch the latest state from remote
- Lock it (if supported)
- Perform plan/apply
- Push new state back to the backend

## ⚙️ Azure Remote Backend Example
We'll use Azure Blob Storage as the remote backend.

**Directory Structure:**
```
remote-backend/
├── backend.tf        # remote backend config
├── main.tf           # terraform resources
```

### 🔐 Step 1: Create Azure Resources for Backend
You can do this via Azure CLI or Terraform:

**Azure CLI:**
```bash
# Set vars
RESOURCE_GROUP="tfstate-rg"
STORAGE_ACCOUNT="pavanterraformstate"
CONTAINER_NAME="tfstate"

# Create resource group
az group create -n $RESOURCE_GROUP -l eastus

# Create storage account
az storage account create -n $STORAGE_ACCOUNT -g $RESOURCE_GROUP -l eastus --sku Standard_LRS

# Create container
az storage container create --account-name $STORAGE_ACCOUNT --name $CONTAINER_NAME
```

### 📜 Step 2: Define Remote Backend (in backend.tf)
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "pavanterraformstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
```
The key is like the file name for your `.tfstate` in the container.

> ⚠️ You should not use variables in backend block — use hardcoded values or partial configuration via CLI.

### 🧱 Step 3: Sample Main File (main.tf)
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}
```

### ▶️ Step 4: Initialize Terraform
```bash
terraform init
```
Terraform will detect the remote backend and prompt to migrate existing state if needed.

## 📌 Commands Summary
| Command                  | Purpose                      |
|--------------------------|------------------------------|
| terraform init           | Initializes backend config   |
| terraform plan           | Uses remote state            |
| terraform apply          | Updates remote state         |
| terraform state list     | Views current remote state   |
| terraform state show <resource> | See full remote state data |

## 🧠 Best Practices
| Tip                                         | Why                                 |
|----------------------------------------------|-------------------------------------|
| Use separate state per environment           | Isolation                           |
| Enable versioning on Azure Blob              | Rollbacks                           |
| Restrict access to state container           | Prevent tampering                   |
| Use service principals or Managed Identities | Secure auth                         |
| Use locking with Terraform Cloud or implement your own | Prevent simultaneous applies |

## ⚠️ Common Pitfalls
| Mistake                          | Fix                                      |
|-----------------------------------|------------------------------------------|
| Using local state in team projects| Always use remote backend                |
| Forgetting terraform init after changing backend | Run terraform init -reconfigure |
| Using variables inside backend block | Use hardcoded or CLI overrides instead |

## 🧪 Optional: Partial Configuration Example
You can leave some backend config empty and pass via CLI:
```hcl
terraform {
  backend "azurerm" {}
}
```
```bash
terraform init \
  -backend-config="resource_group_name=tfstate-rg" \
  -backend-config="storage_account_name=pavanterraformstate" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=dev.terraform.tfstate"
```

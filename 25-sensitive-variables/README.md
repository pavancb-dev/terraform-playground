# 🔐 Sensitive Variables & Secrets Management in Terraform

## 📌 What Is It?
Terraform often needs access to secrets or sensitive values such as:
- API keys
- Passwords
- Cloud credentials (like Azure Client Secrets)
- SSH private keys
- DB connection strings

Terraform provides mechanisms to mark variables as sensitive, avoid printing them in logs, and integrate with secure secret stores.

## 🧩 Key Concepts
| Concept                  | Purpose                                         |
|--------------------------|-------------------------------------------------|
| sensitive = true         | Hides variable values in logs/plan/apply output |
| Environment variables    | Securely pass secrets via shell/CI              |
| .tfvars files            | Store secrets separately from main config       |
| Remote backends (Key Vault)| Integrate secure secret retrieval            |
| External data sources    | Fetch secrets from scripts or vaults dynamically|

## 🛠️ Example 1: Declaring a Sensitive Variable
```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```
Then pass it securely:
```bash
terraform apply -var="db_password=SuperSecret123!"
```
or from a `secrets.tfvars` file (don't commit this file):
```hcl
db_password = "SuperSecret123!"
```

## 🧪 Using the Sensitive Variable
```hcl
resource "azurerm_postgresql_flexible_server" "db" {
  name                = "my-pgsql"
  ...
  administrator_login_password = var.db_password
}
```
> ⚠️ Important: Sensitive values are still stored in state
> Even if marked sensitive, the value is visible in `terraform.tfstate`, unless you encrypt and protect it (via remote backends like Azure Blob Storage with encryption).

## 🧩 Example 2: Mark Output as Sensitive
```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```
Even when someone runs:
```bash
terraform output
```
They will see:
```
db_password = (sensitive value)
```
To actually see it (not recommended):
```bash
terraform output -json | jq -r '.db_password.value'
```

## 🧩 Example 3: Use Environment Variables
You can pass secrets to Terraform using environment variables:
```bash
export TF_VAR_db_password="SuperSecret123!"
terraform apply
```
Terraform will automatically map this to `var.db_password`.

## 🧩 Example 4: Integrate Azure Key Vault (Advanced)
Use the data source with external providers or automation to pull secrets:
```hcl
data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  key_vault_id = azurerm_key_vault.kv.id
}
```
Then pass:
```hcl
administrator_login_password = data.azurerm_key_vault_secret.db_password.value
```
This is more secure than storing in `.tfvars` or shell history.

## ✅ Best Practices
| Practice                        | Why                                 |
|----------------------------------|-------------------------------------|
| Always mark secrets as sensitive | Prevents exposure in logs or output |
| Use remote state with encryption | Keeps secrets safe at rest          |
| Don’t commit .tfvars or secrets to Git | Prevents credential leaks      |
| Use CI/CD secrets manager to inject vars | Avoid hardcoding secrets      |
| Avoid printing outputs of secrets | Mark them sensitive in output block |
| Rotate secrets periodically      | Security hygiene                    |

## ⚠️ Common Pitfalls
| Pitfall                        | Problem                              |
|-------------------------------|--------------------------------------|
| Printing secrets via output or logs | Security risk                    |
| Committing secrets.tfvars to Git    | Huge vulnerability               |
| Assuming sensitive = true hides in state | It doesn’t                  |
| Using plain text in scripts or pipelines | Risk of leaking             |
| Using hardcoded secrets in .tf files     | Avoid completely             |

## 🔒 CI/CD Secure Injection Tips
Use GitHub Actions secrets, Azure DevOps Library, or GitLab CI secrets

**Example in GitHub Actions:**
```yaml
env:
  TF_VAR_db_password: ${{ secrets.DB_PASSWORD }}
```

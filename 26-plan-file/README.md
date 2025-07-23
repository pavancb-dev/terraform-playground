# 📐 Terraform Plan File (.tfplan)

## 📌 What Is It?
A plan file is a binary output file created by `terraform plan` that records:
- The exact changes Terraform will make
- All computed values (from variables, resources, outputs, etc.)
- Any pending destruction, creation, or updates

This file can then be safely passed to `terraform apply` to ensure exact execution, even in automated pipelines.

## 🎯 Why Use Plan Files?
| Benefit      | Why it matters                                   |
|--------------|--------------------------------------------------|
| 🔐 Security  | Plan can be reviewed by others before applying (approval workflows) |
| 🤖 Automation| Easily used in CI/CD for gated deployments        |
| ✅ Predictability| Guarantees that apply does exactly what was planned |
| 🧾 Auditing  | Stores an immutable snapshot of proposed infra changes |

## 🛠️ How to Use
### Step 1: Generate Plan File
```bash
terraform plan -out=tfplan
```
This saves the execution plan to a binary file called `tfplan`.

### Step 2: Apply Using Plan File
```bash
terraform apply tfplan
```
This guarantees Terraform applies only what was planned earlier, even if `.tf` files or variable values change later.

### Optional: Use Variable Files
```bash
terraform plan -var-file="prod.tfvars" -out="prod.tfplan"
terraform apply "prod.tfplan"
```

## 👀 Inspecting Plan File (Not Directly Human-Readable)
You can’t open `tfplan` with a text editor—it’s a binary file. But you can use:
```bash
terraform show tfplan
```
To view a human-readable version of the plan.

To get it in JSON (for automation or audits):
```bash
terraform show -json tfplan > tfplan.json
```

## 📁 Real-World Workflow (CI/CD Style)
```bash
# Generate plan file (e.g., in CI)
terraform plan -var-file="dev.tfvars" -out="dev.tfplan"

# Send to code reviewer, or store in blob storage

# Apply only that plan
terraform apply "dev.tfplan"
```

## 🔐 Best Practices
| Practice                          | Why                                         |
|------------------------------------|---------------------------------------------|
| Always use -out in CI/CD pipelines | Prevents environment drift                  |
| Use unique names like dev.tfplan, prod.tfplan | Avoids confusion                  |
| Don’t commit .tfplan to Git        | Contains sensitive values in binary         |
| Use terraform show -json for logging/audits | Machine-readable audit trails      |
| Use plan+approval pattern in prod  | Safer and reviewable infrastructure changes |

## ⚠️ Common Pitfalls
| Pitfall                           | Problem                                     |
|-----------------------------------|---------------------------------------------|
| Modifying code between plan and apply | Makes plan invalid (may error out or misapply) |
| Trying to read .tfplan directly   | It’s binary; use terraform show instead      |
| Not using plan in automation      | Increases risk of unreviewed or unapproved changes |
| Assuming plan is secure           | It may still include sensitive values! Use secure storage |

## 🔍 Bonus: Safe CI/CD Strategy with Plan Approval
```bash
terraform plan -out=tfplan

Upload tfplan to blob/S3/artifact

Require manual approval (via Azure DevOps, GitHub, GitLab)

Reviewer runs: terraform apply tfplan
```

# 🔒 Terraform State Locking

## ✅ What Is State Locking?
State locking is a mechanism that prevents multiple people or processes from making simultaneous changes to your Terraform state file.

When enabled:
- Terraform locks the state before running plan or apply
- No one else can modify the state until it's unlocked
- Helps avoid race conditions, corrupt state, and partial applies

## 🚫 Why You Need State Locking
Without state locking:
- Two people might overwrite each other's changes
- Terraform could apply changes with an outdated plan
- The `.tfstate` file could become corrupted or inconsistent

## 🧠 How State Locking Works
| Step | Description                                      |
|------|--------------------------------------------------|
| 1    | Terraform checks if a lock exists on the state   |
| 2    | If not, it creates a lock (e.g., blob lease in Azure) |
| 3    | If a lock exists, Terraform waits or errors out  |
| 4    | Once done, Terraform releases the lock           |

## ☁️ Azure State Locking
When using Azure Blob Storage as a remote backend:
- Blob Lease acts as a lock
- Terraform uses this automatically

> 📌 If you're already using remote backend on Azure, locking is built-in — no extra config required

## 🔐 Locking in Other Providers
| Provider         | Locking Support | Notes                          |
|------------------|----------------|--------------------------------|
| Azure Blob       | ✅ Yes          | Built-in                       |
| S3               | ❌ No by default| Use DynamoDB table for locking |
| Terraform Cloud  | ✅ Yes          | Built-in                       |
| Consul           | ✅ Yes          | Built-in                       |
| Local Backend    | ❌ No           | No locking support             |

## ⚙️ CLI Options
| Command                          | Purpose                        |
|-----------------------------------|--------------------------------|
| terraform apply -lock=false       | Skips locking — ⚠️ not recommended |
| terraform force-unlock <LOCK_ID>  | Manually removes a stuck lock  |

> ⚠️ Use force-unlock only if you're sure the other process is dead or stuck.

## 🔒 Example Locking Scenario
Let's say Dev1 runs:
```bash
terraform apply
```
While apply is running, Dev2 tries:
```bash
terraform apply
```
Result:
```bash
╷
│ Error: Error acquiring the state lock
│ 
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue by 
│ using the `terraform force-unlock` command if you're certain this is safe.
│ 
│ Lock Info:
│   ID:        572e4b8e-7f1a-8b0a-92b3-fd0e4b91ed6d
│   Path:      <state path>
│   Operation: OperationTypeApply
│   Who:       yourname@hostname
│   Version:   x.y.z
│   Created:   2025-07-19 07:43:00.123 +0000 UTC
│   Info:      Planning
╵
```
Terraform will wait (default timeout) or fail, depending on configuration.

### 🔐 Example: Forcing Unlock (Azure, S3, etc.)
```bash
terraform force-unlock 572e4b8e-7f1a-8b0a-92b3-fd0e4b91ed6d
```

## ✅ Best Practices
| Tip                                         | Why                                 |
|----------------------------------------------|-------------------------------------|
| Always use a remote backend that supports locking | Protects your infra           |
| Avoid disabling lock unless in read-only mode     | Prevents corruption              |
| Use force-unlock cautiously                       | May cause unintended side effects |

## ⚠️ Common Pitfalls
| Mistake                | Consequence                        |
|------------------------|------------------------------------|
| Skipping lock (-lock=false) | Risk of conflicting state updates |
| Killing terraform apply midway | Can leave state locked         |
| Forgetting to unlock         | Others are blocked              |
| Using local backend          | No locking = high risk          |

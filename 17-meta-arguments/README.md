# 🧩 Terraform Meta-Arguments

## ✅ What Are Meta-Arguments?
Meta-arguments are special Terraform arguments that change the behavior of a resource block (not the resource itself). They're built-in and universal, and not specific to a provider (like Azure, AWS, etc.).

## 📋 List of Core Meta-Arguments
| Meta-Argument | Purpose                                 |
|--------------|------------------------------------------|
| count        | Create multiple copies of a resource      |
| for_each     | Create resources for each element in a map or set |
| provider     | Use a specific provider instance          |
| depends_on   | Explicitly define resource dependencies   |
| lifecycle    | Control resource lifecycle (already covered earlier) |

---

## 1️⃣ count
**Purpose:** Creates N number of copies of a resource based on a number

**Example:**
```hcl
variable "rg_count" {
  type    = number
  default = 2
}

resource "azurerm_resource_group" "example" {
  count    = var.rg_count
  name     = "rg-count-${count.index}"
  location = "East US"
}
```
💡 `count.index` gives the current iteration index (0, 1, ...).

---

## 2️⃣ for_each
**Purpose:** Creates one resource per key/value in a map or value in a set

**Example (using Map):**
```hcl
variable "rg_map" {
  type = map(string)
  default = {
    dev  = "East US"
    prod = "West Europe"
  }
}

resource "azurerm_resource_group" "example" {
  for_each = var.rg_map

  name     = "rg-${each.key}"
  location = each.value
}
```
✅ This is more readable and flexible than count when working with named items.

---

## 3️⃣ provider
**Purpose:** Use a specific alias of a provider (e.g., different Azure subscriptions or regions)

**Example:**
```hcl
provider "azurerm" {
  alias   = "west"
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

provider "azurerm" {
  alias   = "east"
  features {}
  subscription_id = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
}

resource "azurerm_resource_group" "west_rg" {
  provider = azurerm.west
  name     = "rg-west"
  location = "West US"
}

resource "azurerm_resource_group" "east_rg" {
  provider = azurerm.east
  name     = "rg-east"
  location = "East US"
}
```
🔐 Use this to deploy across multiple subscriptions or regions from the same Terraform config.

---

## 4️⃣ depends_on
**Purpose:** Manually define dependencies between resources

Normally Terraform auto-detects dependencies. But you use depends_on when:
- The dependency is implicit
- You want to delay execution until another resource finishes

**Example:**
```hcl
resource "null_resource" "first" {
  provisioner "local-exec" {
    command = "echo First resource"
  }
}

resource "null_resource" "second" {
  depends_on = [null_resource.first]

  provisioner "local-exec" {
    command = "echo Second resource"
  }
}
```
✅ `second` won’t run until `first` finishes.

---

## Comparison Table
| Meta-Argument | Best Used When                       |
|--------------|--------------------------------------|
| count        | Repeat N times (numeric count)        |
| for_each     | Iterate over map/set (named things)   |
| provider     | Deploy across multiple accounts/regions|
| depends_on   | You need to force dependency          |
| lifecycle    | Already covered: manage create/delete/ignore behavior |

---

## ✅ Best Practices for Meta-Arguments
### 🟩 General
| Practice | Why It Matters |
|----------|----------------|
| Use for_each over count when working with named values | Avoids accidental replacement of resources when the order changes |
| Always use each.key / each.value in for_each | Makes code readable and traceable |
| Use depends_on only when needed | Let Terraform manage dependencies automatically when possible |
| Declare provider alias clearly and document its purpose | Reduces confusion when working with multi-region/multi-account |
| Combine count or for_each with locals or well-named variables | Helps organize repetitive deployments |

### 🟩 count
- Use count when you want a fixed number of resources
- Guard resource creation with `count = var.enabled ? 1 : 0` for optional resources
- Avoid count with dynamic lists that change length — it can cause resource recreation

### 🟩 for_each
- Use for_each when resources have unique names or attributes
- Use maps/sets over lists for clarity
- Access each.key and each.value precisely

### 🟩 provider
- Use clear, descriptive aliases like east_us, prod, or backup
- Isolate provider blocks per region/account to avoid confusion
- Use workspaces or modules to separate envs if possible

### 🟩 depends_on
- Use for indirect dependencies that Terraform can't detect automatically (e.g., provisioners, local-exec)
- Don’t abuse it — unnecessary use can create tight coupling and slow down applies

---

## 🚫 Common Pitfalls
| Pitfall | Why It’s Bad |
|---------|-------------|
| Using count with lists that change | Will replace all downstream resources unexpectedly |
| Mixing count and for_each on same resource type | Makes logic complex and error-prone |
| Overusing depends_on | Breaks Terraform's natural DAG flow and slows down apply |
| Not setting provider when multiple aliases exist | Leads to wrong-region or wrong-subscription deployments |
| Hardcoding index with count (count.index) | Becomes brittle when list changes |

---

## 🧼 Naming & Standards
| Convention | Example |
|------------|---------|
| Name resource with prefix/suffix of loop index/key | azurerm_rg.app_env["dev"], rg-${count.index} |
| Use lowercase and underscores in provider aliases | azurerm.dev_subscription |
| Use locals to precompute maps/lists for cleaner loops | locals.rgs = { dev = "East US", prod = "West Europe" } |

---

## 🧠 Summary: When to Use What?
| Use Case                        | Use         |
|----------------------------------|-------------|
| Fixed number of similar resources| count       |
| Named and different resources    | for_each    |
| Deploying to multiple accounts/regions | provider (with alias) |
| Manual dependency chaining       | depends_on  |

# 🧮 Terraform Console — Expression Evaluation Playground

## 📌 What Is terraform console?
The terraform console is an interactive REPL (Read-Eval-Print Loop) that lets you experiment with:
- Expressions and interpolations
- Built-in functions
- Variables and locals
- Outputs and data sources (after terraform apply)

Think of it as a sandbox to test Terraform logic without running a full plan or apply.

## ✅ When to Use It?
- Test a lookup, element, join, split, or regex function
- See how variables or local values are evaluated
- Experiment with dynamic blocks or complex conditionals
- Debug unexpected outputs or expressions in your configuration

## 🛠️ Usage
Run this in the root of your Terraform project:
```bash
terraform console
```
You’ll enter a prompt like this:
```
>
```

## 🧪 Example Usages
### 🎯 Basic Expression
```hcl
> 1 + 2
3
```

### 🔍 Interpolation
```hcl
> "${upper("eastus")}"
"EASTUS"
```

### 🧵 String Join
```hcl
> join(",", ["one", "two", "three"])
"one,two,three"
```

### 🔁 Loop Evaluation
```hcl
> [for x in [1, 2, 3] : x * 2]
[
  2,
  4,
  6,
]
```

### 🔄 Map Lookup
```hcl
> lookup({ "dev" = "t2.micro", "prod" = "t2.large" }, "prod", "t2.nano")
"t2.large"
```

### 📦 Accessing Terraform State Values
After running terraform apply, you can access state data:
```hcl
> var.project_name
"demoapp"

> local.resource_prefix
"demoapp-dev"

> azurerm_resource_group.rg.name
"demoapp-rg"
```

## ⚙️ Preloading Variables in Console (Optional)
If you want to test variables without applying, set them via:
```bash
terraform console -var='env=dev' -var='region=eastus'
```

## ✅ Best Practices
| Practice                                 | Benefit                                 |
|------------------------------------------|-----------------------------------------|
| Use it before writing complex expressions| Validate syntax                         |
| Explore output from modules/resources    | Avoid trial-error in code               |
| Test Terraform functions in isolation    | Faster development                      |
| Use with terraform apply for real state introspection | See actual values and dependencies |

## ⚠️ Common Pitfalls
| Pitfall                                  | Why it Happens                          |
|------------------------------------------|-----------------------------------------|
| Variables or outputs show <unknown>      | You haven’t applied yet                 |
| Can't access data sources                | They aren’t evaluated until plan/apply  |
| Forgetting to exit console               | Use exit or Ctrl+D to leave             |
| Doesn’t work outside initialized directory| Always run it inside a Terraform project with terraform init done |

## 🚪 Exit the Console
```
> exit
```

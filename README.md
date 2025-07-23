# 🚀 Terraform Mastery: From Beginner to Pro

[![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Cloud-Azure-0078D4?logo=microsoft-azure)](https://azure.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

This repository is a **complete, hands-on learning path** for mastering **Terraform with Azure**. Whether you're new to Infrastructure as Code or preparing for cloud DevOps roles, this guide takes you from the very basics to advanced.

---

## 📚 Table of Contents

1. [🧰 Setup & Basics](#-setup--basics)
2. [🔁 Input, Output & Configuration](#-input-output--configuration)
3. [📦 Code Reusability & Modularity](#-code-reusability--modularity)
4. [🧠 State Management & Environment Isolation](#-state-management--environment-isolation)
5. [🔍 Reading & Controlling Existing Infrastructure](#-reading--controlling-existing-infrastructure)
6. [⚙️ Lifecycle Control & Resource Management](#️-lifecycle-control--resource-management)
7. [🔬 Testing, Debugging & CLI Tools](#-testing-debugging--cli-tools)

---

## 🧰 Setup & Basics

| Concept | Description |
|--------|-------------|
| ✅ [Installing Terraform & Azure CLI](./00-setup) | Setup tools and authenticate with Azure |
| ✅ [Terraform Commands](./01-commands) | Core commands: `init`, `plan`, `apply`, `destroy` |
| ✅ [Terraform Language (HCL)](./03-language) | Understand syntax, blocks, and structure |
| ✅ [Providers](./04-providers) | Connect to Azure and other cloud APIs |
| ✅ [Resources](./05-resources) | Define infrastructure components |

---

## 🔁 Input, Output & Configuration

| Concept | Description |
|--------|-------------|
| ✅ [Variables](./06-variables) | Parameterize your configuration |
| ✅ [Outputs](./07-outputs) | Export values from your infrastructure |
| ✅ [Locals](./08-locals) | Define reusable local values |
| ✅ [Expressions & Interpolation](./09-expressions) | Build dynamic values using logic |

---

## 📦 Code Reusability & Modularity

| Concept | Description |
|--------|-------------|
| ✅ [Functions](./10-functions) | Built-in helpers for string, math, etc. |
| ✅ [Meta-Arguments](./11-meta-arguments) | `count`, `for_each`, `depends_on`, etc. |
| ✅ [Dynamic Blocks](./12-dynamic-blocks) | Generate nested blocks dynamically |
| ✅ [Modules](./13-modules) | Reuse Terraform config via local and remote modules |
| ✅ [Registry Integration](./14-registry) | Pull modules and providers from Terraform Registry |

---

## 🧠 State Management & Environment Isolation

| Concept | Description |
|--------|-------------|
| ✅ [State](./15-state) | Track managed resources |
| ✅ [Remote Backends](./16-remote-backends) | Store state in Azure blob or S3 |
| ✅ [State Locking](./17-state-locking) | Prevent concurrent apply issues |
| ✅ [Workspaces](./18-workspaces) | Manage environments like dev/stage/prod |
| ✅ [Sensitive Variables](./19-sensitive) | Secure secrets and sensitive data |
| ✅ [Plan File](./20-plan-file) | Use `.tfplan` for safe, repeatable deploys |

---

## 🔍 Reading & Controlling Existing Infrastructure

| Concept | Description |
|--------|-------------|
| ✅ [Data Sources](./21-data-sources) | Reference existing resources dynamically |
| ✅ [Import](./22-import) | Bring external resources into Terraform |
| ✅ [Dependency Graph](./23-dependency-graph) | Visualize resource relationships |

---

## ⚙️ Lifecycle Control & Resource Management

| Concept | Description |
|--------|-------------|
| ✅ [Lifecycle Block](./24-lifecycle) | Fine-tune create, update, and delete behavior |
| ✅ [Taint / Untaint](./25-taint-untaint) | Force recreation of broken resources |
| ✅ [Provisioners](./26-provisioners) | Run scripts or commands during resource creation |

---

## 🔬 Testing, Debugging & CLI Tools

| Concept | Description |
|--------|-------------|
| ✅ [Console](./27-console) | Terraform REPL to test expressions |
| ✅ [Terraform CLI Automation](./28-cli-automation) | Scripting with CLI commands |
| ✅ [Testing & Validation](./29-testing) | Use `validate`, `tflint`, `checkov` for quality checks |

---

## 📌 License

This repository is licensed under the [MIT License](./LICENSE).

---

## 🙌 Contributing

Contributions, corrections, and suggestions are welcome! Please open an issue or submit a PR.

---

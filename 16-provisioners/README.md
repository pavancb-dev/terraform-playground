# ⚙️ Terraform Provisioners

## ✅ What Are Provisioners?
Provisioners in Terraform are used to run scripts or commands on a local machine or remote resource after it’s created (or destroyed).

They are often used for:
- Bootstrapping servers (installing software, setting config)
- Running custom scripts
- Copying files to remote machines

> ⚠️ **Important Warning:** Provisioners should be your last resort. If the task can be done through providers or resources (like cloud-init, user_data, Packer, etc.), do that instead. Provisioners break idempotency (i.e., repeatable and predictable runs).

## ✨ Types of Provisioners
| Provisioner   | Description                                 |
|--------------|---------------------------------------------|
| local-exec    | Runs a script/command on your local machine |
| remote-exec   | Runs commands on the created resource via SSH or WinRM |
| file          | Uploads files from local to remote machine  |

## 🔧 1. local-exec Example
```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello from Terraform > hello.txt"
  }
}
```
📌 This runs a command on your machine, not on a VM or cloud resource.

## 🔧 2. remote-exec Example (Azure VM)
```hcl
resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "echo 'Hello from Terraform' > /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip_address
    }
  }
}
```

## 🔧 3. file Provisioner Example
```hcl
provisioner "file" {
  source      = "myapp.conf"
  destination = "/etc/myapp/config.conf"

  connection {
    type        = "ssh"
    host        = self.public_ip_address
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
  }
}
```

## 🧼 Cleanup with provisioner "destroy"
Provisioners can also run on destroy:
```hcl
provisioner "local-exec" {
  when    = "destroy"
  command = "echo Destroying the resource!"
}
```

## ✅ Best Practices
| Best Practice                                 | Why                                 |
|-----------------------------------------------|-------------------------------------|
| Prefer user_data, cloud-init, startup scripts | More reliable & repeatable          |
| Use null_resource + provisioner if needed     | Keeps infra separate from scripts   |
| Handle failures explicitly with on_failure    | Prevents unintended halts           |
| Avoid long/complex scripts inline             | Keep them in separate files         |

## ⚠️ Common Pitfalls
| Problem                  | Explanation                        |
|--------------------------|------------------------------------|
| Provisioner fails randomly| Due to timing, VM not ready, network latency |
| Not idempotent           | Running again doesn’t behave the same way |
| Provisioner depends on local env | Not portable                |
| Hard to debug            | Output may be buried or incomplete |

## 🧠 When to Use Provisioners
✅ Okay to use when:
- You need to set up something after infra is ready
- There’s no other way to do it declaratively

❌ Avoid if:
- You can use cloud-init, user_data, or Packer images
- You want fully reliable and repeatable infrastructure

provider "azurerm" {
  features {}
}

variable "rg_count" {
  type    = number
  default = 2
}

resource "azurerm_resource_group" "example" {
  count    = var.rg_count
  name     = "rg-count-${count.index}"
  location = "East US"
}

output "rg_element" {
  value = element(azurerm_resource_group.example[*].name, 0)
}

output "rg_index" {
  value = azurerm_resource_group.example[1].name
}

output "rg_ids" {
  value = azurerm_resource_group.example[*].id
}


variable "rg_map" {
  type = map(string)
  default = {
    dev  = "East US"
    prod = "West Europe"
  }
}

resource "azurerm_resource_group" "rg_map" {
  for_each = var.rg_map
  name     = "rg-${each.key}"
  location = each.value
}

output "dev_rg_id" {
  value = azurerm_resource_group.rg_map["dev"].id
}

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
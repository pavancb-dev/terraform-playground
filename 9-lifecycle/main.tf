terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }
  required_version = "~> 1.12.2"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "critical-rg" {
  name     = "critical-rg"
  location = "East US"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "mydemoacct123"
  resource_group_name      = azurerm_resource_group.critical-rg.name
  location                 = azurerm_resource_group.critical-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [tags]
    create_before_destroy = true
  }

  tags = {
    environment = "demo"
    owner       = "paavacb"
  }
}
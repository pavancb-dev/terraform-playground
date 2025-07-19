provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_rg" {
  name     = "demo-rg"
  location = "eastus"
}
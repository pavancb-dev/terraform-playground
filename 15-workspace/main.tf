provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "workspace-rg-${terraform.workspace}"
  location = "East US"
}
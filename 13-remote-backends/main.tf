terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "pavanterraformstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg-${random_integer.rand.result}"
  location = "East US"
}

resource "random_integer" "rand" {
  min = 1
  max = 100
}
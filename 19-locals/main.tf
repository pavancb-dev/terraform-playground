provider "azurerm" {
  features {}
}

locals {
  environment      = "prod"
  location         = "eastus"
  business_unit    = "finance"
  resource_prefix  = "${local.business_unit}-${local.environment}-${local.location}"
  storage_name     = lower(replace(local.resource_prefix, "-", ""))
    common_tags = {
    environment = "dev"
    owner       = "pavan"
    project     = "terraform-azure"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "${local.resource_prefix}-rg"
  location = local.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "example" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}
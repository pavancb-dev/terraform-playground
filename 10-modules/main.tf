provider "azurerm" {
  features {}
}

module "demo_rg" {
  source   = "./modules/resource_group"
  name     = "demo-rg"
  location = "East US"
  tags = {
    Owner = "Pavan"
    Env   = "Dev"
  }
}

output "resource_group_id" {
  value = module.demo_rg.id
}


module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "5.0.1"
  resource_group_name = module.demo_rg.name
  vnet_location = module.demo_rg.location
}

output "vnet_id" {
  value = module.vnet.vnet_id
}
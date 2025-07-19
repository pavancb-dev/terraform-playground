output "resource_group_name" {
  value       = azurerm_resource_group.demo_rg.name
  description = "The name of the Resource Group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.demo_rg.location
  description = "Location of the Resource Group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.demo_storage.name
  description = "Name of the storage account"
}
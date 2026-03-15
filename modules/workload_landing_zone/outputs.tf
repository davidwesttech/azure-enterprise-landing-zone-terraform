output "storage_account_id" {
  description = "ID of the workload storage account."
  value       = azurerm_storage_account.workload.id
}

output "storage_account_name" {
  description = "Name of the workload storage account."
  value       = azurerm_storage_account.workload.name
}

output "key_vault_id" {
  description = "ID of the workload Key Vault."
  value       = azurerm_key_vault.workload.id
}

output "key_vault_name" {
  description = "Name of the workload Key Vault."
  value       = azurerm_key_vault.workload.name
}
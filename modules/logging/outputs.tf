output "resource_group_name" {
  description = "Name of the platform management resource group."
  value       = azurerm_resource_group.management.name
}

output "resource_group_id" {
  description = "ID of the platform management resource group."
  value       = azurerm_resource_group.management.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_workspace_id" {
  description = "Workspace ID used for agents and integrations."
  value       = azurerm_log_analytics_workspace.main.workspace_id
}
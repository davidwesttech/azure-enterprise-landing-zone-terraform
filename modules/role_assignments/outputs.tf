output "subscription_reader_assignment_id" {
  description = "ID of the subscription Reader role assignment."
  value       = azurerm_role_assignment.subscription_reader.id
}

output "workload_contributor_assignment_id" {
  description = "ID of the workload Contributor role assignment."
  value       = azurerm_role_assignment.workload_contributor.id
}
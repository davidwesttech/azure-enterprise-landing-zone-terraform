output "allowed_locations_assignment_id" {
  description = "ID of the allowed locations policy assignment."
  value       = azurerm_subscription_policy_assignment.allowed_locations.id
}

output "require_environment_tag_assignment_id" {
  description = "ID of the require environment tag policy assignment."
  value       = azurerm_subscription_policy_assignment.require_environment_tag.id
}
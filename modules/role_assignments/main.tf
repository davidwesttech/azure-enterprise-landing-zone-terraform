resource "azurerm_role_assignment" "subscription_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = var.principal_object_id
}

resource "azurerm_role_assignment" "workload_contributor" {
  scope                = var.workload_resource_group_id
  role_definition_name = "Contributor"
  principal_id         = var.principal_object_id
}
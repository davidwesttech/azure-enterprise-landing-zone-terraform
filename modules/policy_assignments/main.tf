data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag on resources"
}

resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "Allowed Locations"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  description          = "Restrict resource deployments to approved Azure regions."

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

resource "azurerm_subscription_policy_assignment" "require_environment_tag" {
  name                 = "require-environment-tag"
  display_name         = "Require Environment Tag"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.require_tag.id
  description          = "Require the environment tag on deployed resources."

  parameters = jsonencode({
    tagName = {
      value = var.required_tag_name
    }
  })
}
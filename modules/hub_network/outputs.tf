output "resource_group_name" {
  description = "Name of the connectivity resource group."
  value       = azurerm_resource_group.connectivity.name
}

output "resource_group_id" {
  description = "ID of the connectivity resource group."
  value       = azurerm_resource_group.connectivity.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.hub.name
}

output "hub_vnet_id" {
  description = "ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "shared_services_subnet_id" {
  description = "ID of the shared services subnet."
  value       = azurerm_subnet.shared_services.id
}

output "azure_firewall_subnet_id" {
  description = "ID of the AzureFirewallSubnet."
  value       = azurerm_subnet.azure_firewall.id
}

output "gateway_subnet_id" {
  description = "ID of the GatewaySubnet."
  value       = azurerm_subnet.gateway.id
}
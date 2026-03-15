output "resource_group_name" {
  description = "Name of the workload resource group."
  value       = azurerm_resource_group.workload.name
}

output "resource_group_id" {
  description = "ID of the workload resource group."
  value       = azurerm_resource_group.workload.id
}

output "spoke_vnet_name" {
  description = "Name of the spoke virtual network."
  value       = azurerm_virtual_network.spoke.name
}

output "spoke_vnet_id" {
  description = "ID of the spoke virtual network."
  value       = azurerm_virtual_network.spoke.id
}

output "app_subnet_id" {
  description = "ID of the application subnet."
  value       = azurerm_subnet.app.id
}

output "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet."
  value       = azurerm_subnet.private_endpoints.id
}
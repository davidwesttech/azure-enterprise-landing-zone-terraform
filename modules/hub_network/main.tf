resource "azurerm_resource_group" "connectivity" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "shared_services" {
  name                 = var.shared_services_subnet_name
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.shared_services_subnet_prefixes
}

resource "azurerm_subnet" "azure_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.firewall_subnet_prefixes
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.gateway_subnet_prefixes
}
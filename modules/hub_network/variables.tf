variable "location" {
  description = "Azure region for hub network resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the connectivity resource group."
  type        = string
}

variable "vnet_name" {
  description = "Name of the hub virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the hub virtual network."
  type        = list(string)
}

variable "shared_services_subnet_name" {
  description = "Name of the shared services subnet."
  type        = string
  default     = "snet-shared-services"
}

variable "shared_services_subnet_prefixes" {
  description = "Address prefixes for the shared services subnet."
  type        = list(string)
}

variable "firewall_subnet_prefixes" {
  description = "Address prefixes for the AzureFirewallSubnet."
  type        = list(string)
}

variable "gateway_subnet_prefixes" {
  description = "Address prefixes for the GatewaySubnet."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to hub network resources."
  type        = map(string)
  default     = {}
}
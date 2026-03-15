variable "location" {
  description = "Azure region for spoke network resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the workload resource group."
  type        = string
}

variable "vnet_name" {
  description = "Name of the spoke virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the spoke virtual network."
  type        = list(string)
}

variable "app_subnet_name" {
  description = "Name of the application subnet."
  type        = string
  default     = "snet-app"
}

variable "app_subnet_prefixes" {
  description = "Address prefixes for the application subnet."
  type        = list(string)
}

variable "private_endpoints_subnet_name" {
  description = "Name of the private endpoints subnet."
  type        = string
  default     = "snet-private-endpoints"
}

variable "private_endpoints_subnet_prefixes" {
  description = "Address prefixes for the private endpoints subnet."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to spoke network resources."
  type        = map(string)
  default     = {}
}
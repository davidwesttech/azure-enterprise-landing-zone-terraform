variable "hub_vnet_name" {
  description = "Name of the hub virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name of the hub virtual network."
  type        = string
}

variable "hub_vnet_id" {
  description = "ID of the hub virtual network."
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network."
  type        = string
}

variable "spoke_resource_group_name" {
  description = "Resource group name of the spoke virtual network."
  type        = string
}

variable "spoke_vnet_id" {
  description = "ID of the spoke virtual network."
  type        = string
}

variable "hub_to_spoke_peering_name" {
  description = "Name of the hub-to-spoke peering."
  type        = string
}

variable "spoke_to_hub_peering_name" {
  description = "Name of the spoke-to-hub peering."
  type        = string
}
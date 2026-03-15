variable "location" {
  description = "Azure region for workload resources."
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

variable "storage_account_name" {
  description = "Name of the storage account."
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID for Key Vault."
  type        = string
}

variable "sku_name" {
  description = "Storage account SKU tier."
  type        = string
  default     = "Standard_LRS"
}

variable "tags" {
  description = "Tags to apply to workload resources."
  type        = map(string)
  default     = {}
}
variable "location" {
  description = "Azure region for logging resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for platform management resources."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention period for Log Analytics data."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to logging resources."
  type        = map(string)
  default     = {}
}
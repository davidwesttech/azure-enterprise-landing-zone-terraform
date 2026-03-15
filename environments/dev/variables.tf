variable "location" {
  description = "Azure region for deployment."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID used for subscription-scoped policy assignments."
  type        = string
}
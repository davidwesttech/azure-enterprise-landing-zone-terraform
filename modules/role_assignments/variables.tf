variable "subscription_id" {
  description = "Azure subscription ID where subscription-scope RBAC will be assigned."
  type        = string
}

variable "workload_resource_group_id" {
  description = "Resource ID of the workload resource group."
  type        = string
}

variable "principal_object_id" {
  description = "Object ID of the principal receiving role assignments."
  type        = string
}
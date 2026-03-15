variable "subscription_id" {
  description = "Subscription ID where policies will be assigned."
  type        = string
}

variable "allowed_locations" {
  description = "List of Azure regions allowed for resource deployment."
  type        = list(string)
}

variable "required_tag_name" {
  description = "Name of the required tag."
  type        = string
}

variable "required_tag_value" {
  description = "Expected value for the required tag policy where applicable."
  type        = string
  default     = ""
}
variable "name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags for the resource group"
  type        = map(string)
  default     = {}
}

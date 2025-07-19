variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "demo-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "random_integer" {
  description = "Random integer min and max values"
  type = map(number)
  default = {
    min = 10000
    max = 99999
  }
}

variable "vnet" {
  description = "Virtual network configuration"
  type        = map(string)
  default = {
    "name" = "demo-vnet"
  }
}

variable "subnet" {
  description = "subnet configuration"
  type = object({
    name             = string
    address_prefixes = list(string)
  })
  default = {
    name             = "demo-subnet"
    address_prefixes = ["10.0.1.0/24"]
  }
}

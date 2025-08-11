variable "name" {
  description = "VPN Gateway name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network name"
  type        = string
}

variable "gateway_subnet_id" {
  description = "Gateway subnet ID"
  type        = string
}

variable "type" {
  description = "Gateway type"
  type        = string
  default     = "Vpn"
}

variable "sku" {
  description = "Gateway SKU"
  type        = string
  default     = "VpnGw1"
}

variable "generation" {
  description = "Gateway generation"
  type        = string
  default     = "Generation1"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
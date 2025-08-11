variable "peering_name_1" {
  description = "Name for first peering connection"
  type        = string
}

variable "peering_name_2" {
  description = "Name for second peering connection"
  type        = string
}

variable "vnet_name_1" {
  description = "First virtual network name"
  type        = string
}

variable "vnet_id_1" {
  description = "First virtual network ID"
  type        = string
}

variable "vnet_name_2" {
  description = "Second virtual network name"
  type        = string
}

variable "vnet_id_2" {
  description = "Second virtual network ID"
  type        = string
}

variable "resource_group_name_1" {
  description = "First resource group name"
  type        = string
}

variable "resource_group_name_2" {
  description = "Second resource group name"
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Allow virtual network access"
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic"
  type        = bool
  default     = false
}

variable "allow_gateway_transit" {
  description = "Allow gateway transit"
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "Use remote gateways"
  type        = bool
  default     = false
}
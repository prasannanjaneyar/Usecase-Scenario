variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "hubspoke"
}

variable "hub_location" {
  description = "Azure region for hub resources"
  type        = string
  default     = "East US"
}

variable "spoke_locations" {
  description = "Azure regions for spoke resources"
  type = map(string)
  default = {
    "spoke1" = "West US"
    "spoke2" = "West Europe"
  }
}

variable "network_config" {
  description = "Network configuration for hub and spokes"
  type = object({
    hub = object({
      vnet_cidr     = string
      gateway_subnet = string
      vm_subnet     = string
    })
    spokes = map(object({
      vnet_cidr = string
      vm_subnet = string
    }))
  })
  default = {
    hub = {
      vnet_cidr     = "10.10.0.0/16"
      gateway_subnet = "10.10.1.0/24"
      vm_subnet     = "10.10.2.0/24"
    }
    spokes = {
      "spoke1" = {
        vnet_cidr = "10.20.0.0/16"
        vm_subnet = "10.20.1.0/24"
      }
      "spoke2" = {
        vnet_cidr = "10.30.0.0/16"
        vm_subnet = "10.30.1.0/24"
      }
    }
  }
}

variable "vm_config" {
  description = "Virtual machine configuration"
  type = object({
    size           = string
    admin_username = string
    admin_password = string
  })
  default = {
    size           = "Standard_B2s"
    admin_username = "azureuser"
    admin_password = "Password123!@#"
  }
}

variable "vpn_config" {
  description = "VPN Gateway configuration"
  type = object({
    sku        = string
    generation = string
    type       = string
  })
  default = {
    sku        = "VpnGw1"
    generation = "Generation1"
    type       = "Vpn"
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "HubSpoke"
    ManagedBy   = "Terraform"
  }
}
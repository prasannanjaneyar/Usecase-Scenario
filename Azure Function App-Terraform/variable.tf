# variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "function_app_name" {
  description = "Name of the function app"
  type        = string
}

variable "service_bus_namespace_name" {
  description = "Name of the Service Bus namespace"
  type        = string
}

variable "service_bus_queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
  default     = "functionqueue"
}

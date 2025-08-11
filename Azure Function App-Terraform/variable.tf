# variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "serverless-functions-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "development"
}

variable "storage_account_name" {
  description = "Name of the storage account (will have suffix added)"
  type        = string
  default     = "serverstorage34567"
  
  validation {
    condition     = can(regex("^[a-z0-9]{3,21}$", var.storage_account_name))
    error_message = "Storage account name must be between 3 and 21 characters long and contain only lowercase letters and numbers."
  }
}

variable "function_app_name" {
  description = "Name of the function app (will have suffix added)"
  type        = string
  default     = "serverless-functions-app"
}

variable "service_bus_namespace_name" {
  description = "Name of the Service Bus namespace (will have suffix added)"
  type        = string
  default     = "serverless-sb-namespace"
}

variable "service_bus_queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
  default     = "process-queue"
}
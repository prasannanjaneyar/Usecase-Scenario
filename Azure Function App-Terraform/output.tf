# outputs.tf
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

output "function_app_name" {
  description = "Name of the created function app"
  value       = azurerm_windows_function_app.function_app.name
}

output "function_app_url" {
  description = "Default hostname of the function app"
  value       = "https://${azurerm_windows_function_app.function_app.default_hostname}"
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.storage.name
}

output "service_bus_namespace_name" {
  description = "Name of the created Service Bus namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.name
}

output "application_insights_name" {
  description = "Name of the created Application Insights instance"
  value       = azurerm_application_insights.insights.name
}

output "service_bus_connection_string" {
  description = "Service Bus connection string"
  value       = azurerm_servicebus_namespace.sb_namespace.default_primary_connection_string
  sensitive   = true
}
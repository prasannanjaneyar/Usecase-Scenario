# outputs.tf
output "function_app_name" {
  value = azurerm_windows_function_app.function_app.name
}

output "function_app_default_hostname" {
  value = azurerm_windows_function_app.function_app.default_hostname
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "service_bus_namespace_name" {
  value = azurerm_servicebus_namespace.sb_namespace.name
}

output "service_bus_queue_name" {
  value = azurerm_servicebus_queue.sb_queue.name
}

output "function_app_triggers_container" {
  value = azurerm_storage_container.function_triggers.name
}
output "id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "VNet name"
  value       = azurerm_virtual_network.this.name
}

output "address_space" {
  description = "VNet address space"
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_names" {
  description = "Subnet names"
  value       = { for k, v in azurerm_subnet.this : k => v.name }
}
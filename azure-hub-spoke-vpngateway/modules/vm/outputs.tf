output "id" {
  description = "VM ID"
  value       = azurerm_linux_virtual_machine.this.id
}

output "name" {
  description = "VM name"
  value       = azurerm_linux_virtual_machine.this.name
}

output "private_ip_address" {
  description = "VM private IP address"
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  description = "VM public IP address"
  value       = azurerm_public_ip.this.ip_address
}
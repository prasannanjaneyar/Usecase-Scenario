output "id" {
  description = "VPN Gateway ID"
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "VPN Gateway name"
  value       = azurerm_virtual_network_gateway.this.name
}

output "public_ip_address" {
  description = "VPN Gateway public IP address"
  value       = azurerm_public_ip.this.ip_address
}
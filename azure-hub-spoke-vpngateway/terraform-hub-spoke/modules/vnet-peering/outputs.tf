output "peering_1_to_2_id" {
  description = "First peering connection ID"
  value       = azurerm_virtual_network_peering.peering_1_to_2.id
}

output "peering_2_to_1_id" {
  description = "Second peering connection ID"
  value       = azurerm_virtual_network_peering.peering_2_to_1.id
}
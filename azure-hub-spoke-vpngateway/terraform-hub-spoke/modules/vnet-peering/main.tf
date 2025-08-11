resource "azurerm_virtual_network_peering" "peering_1_to_2" {
  name                         = var.peering_name_1
  resource_group_name          = var.resource_group_name_1
  virtual_network_name         = var.vnet_name_1
  remote_virtual_network_id    = var.vnet_id_2
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways         = var.use_remote_gateways
  timeouts {
    create = "40m"
    update = "30m"
    delete = "30m"
  }
}

resource "azurerm_virtual_network_peering" "peering_2_to_1" {
  name                         = var.peering_name_2
  resource_group_name          = var.resource_group_name_2
  virtual_network_name         = var.vnet_name_2
  remote_virtual_network_id    = var.vnet_id_1
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = false  # Spoke cannot offer gateway transit
  use_remote_gateways         = true   # Spoke uses hub's gateway
  timeouts {
    create = "40m"
    update = "30m"
    delete = "30m"
  }
}
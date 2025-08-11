# Generate random password for VMs
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# Create Resource Groups
module "hub_rg" {
  source = "./modules/resource-group"
  
  name     = "${var.project_name}-hub-rg"
  location = var.hub_location
  tags     = var.tags
}

module "spoke_rg" {
  source = "./modules/resource-group"
  for_each = var.spoke_locations
  
  name     = "${var.project_name}-${each.key}-rg"
  location = each.value
  tags     = var.tags
}

# Create Hub VNet
module "hub_vnet" {
  source = "./modules/vnet"
  
  name                = "${var.project_name}-hub-vnet"
  location            = var.hub_location
  resource_group_name = module.hub_rg.name
  address_space       = [var.network_config.hub.vnet_cidr]
  
  subnets = {
    "GatewaySubnet" = {
      address_prefixes = [var.network_config.hub.gateway_subnet]
    }
    "vm-subnet" = {
      address_prefixes = [var.network_config.hub.vm_subnet]
    }
  }
  
  tags = var.tags
}

# Create Spoke VNets
module "spoke_vnet" {
  source = "./modules/vnet"
  for_each = var.spoke_locations
  
  name                = "${var.project_name}-${each.key}-vnet"
  location            = each.value
  resource_group_name = module.spoke_rg[each.key].name
  address_space       = [var.network_config.spokes[each.key].vnet_cidr]
  
  subnets = {
    "vm-subnet" = {
      address_prefixes = [var.network_config.spokes[each.key].vm_subnet]
    }
  }
  
  tags = var.tags
}

# Create VNet Peering from Hub to Spokes
module "hub_to_spoke_peering" {
  source = "./modules/vnet-peering"
  for_each = var.spoke_locations
  
  peering_name_1                = "hub-to-${each.key}"
  peering_name_2                = "${each.key}-to-hub"
  vnet_name_1                   = module.hub_vnet.name
  vnet_id_1                     = module.hub_vnet.id
  vnet_name_2                   = module.spoke_vnet[each.key].name
  vnet_id_2                     = module.spoke_vnet[each.key].id
  resource_group_name_1         = module.hub_rg.name
  resource_group_name_2         = module.spoke_rg[each.key].name
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = true  # Hub allows gateway transit
  use_remote_gateways          = false  # Spoke uses remote gateway
  # Add this dependency to ensure gateway is created first
  #gateway_dependency = module.vpn_gateway.gateway_id

  # Make sure peering waits for both VNets and the gateway
  depends_on = [
    module.hub_vnet,
    module.spoke_vnet,
    module.vpn_gateway
  ]
}

# Create VPN Gateway in Hub
module "vpn_gateway" {
  source = "./modules/vpn-gateway"
  
  name                = "${var.project_name}-hub-vpn-gw"
  location            = var.hub_location
  resource_group_name = module.hub_rg.name
  
  virtual_network_name = module.hub_vnet.name
  gateway_subnet_id    = module.hub_vnet.subnet_ids["GatewaySubnet"]
  
  sku        = var.vpn_config.sku
  generation = var.vpn_config.generation
  type       = var.vpn_config.type
  
  tags = var.tags
  
  depends_on = [module.hub_vnet]
}

# Create Virtual Machines
module "hub_vm" {
  source = "./modules/virtual-machine"
  
  name                = "${var.project_name}-hub-vm"
  location            = var.hub_location
  resource_group_name = module.hub_rg.name
  
  subnet_id      = module.hub_vnet.subnet_ids["vm-subnet"]
  vm_size        = var.vm_config.size
  admin_username = var.vm_config.admin_username
  admin_password = random_password.vm_password.result
  
  tags = var.tags
}

module "spoke_vm" {
  source = "./modules/virtual-machine"
  for_each = var.spoke_locations
  
  name                = "${var.project_name}-${each.key}-vm"
  location            = each.value
  resource_group_name = module.spoke_rg[each.key].name
  
  subnet_id      = module.spoke_vnet[each.key].subnet_ids["vm-subnet"]
  vm_size        = var.vm_config.size
  admin_username = var.vm_config.admin_username
  admin_password = random_password.vm_password.result
  
  tags = var.tags
}
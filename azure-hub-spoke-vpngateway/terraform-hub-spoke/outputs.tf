output "hub_vnet_id" {
  description = "Hub VNet ID"
  value       = module.hub_vnet.id
}

output "spoke_vnet_ids" {
  description = "Spoke VNet IDs"
  value       = { for k, v in module.spoke_vnet : k => v.id }
}

output "vpn_gateway_public_ip" {
  description = "VPN Gateway Public IP"
  value       = module.vpn_gateway.public_ip_address
}

output "vm_private_ips" {
  description = "Private IP addresses of all VMs"
  value = {
    hub = module.hub_vm.private_ip_address
    spokes = { for k, v in module.spoke_vm : k => v.private_ip_address }
  }
}

output "vm_public_ips" {
  description = "Public IP addresses of all VMs"
  value = {
    hub = module.hub_vm.public_ip_address
    spokes = { for k, v in module.spoke_vm : k => v.public_ip_address }
  }
}

output "admin_password" {
  description = "Generated admin password for VMs"
  value       = random_password.vm_password.result
  sensitive   = true
}

output "connectivity_test_commands" {
  description = "Commands to test connectivity between VMs"
  value = {
    from_hub_to_spoke1 = "ssh ${var.vm_config.admin_username}@${module.hub_vm.public_ip_address} 'ping -c 4 ${module.spoke_vm["spoke1"].private_ip_address}'"
    from_hub_to_spoke2 = "ssh ${var.vm_config.admin_username}@${module.hub_vm.public_ip_address} 'ping -c 4 ${module.spoke_vm["spoke2"].private_ip_address}'"
    from_spoke1_to_hub = "ssh ${var.vm_config.admin_username}@${module.spoke_vm["spoke1"].public_ip_address} 'ping -c 4 ${module.hub_vm.private_ip_address}'"
    from_spoke2_to_hub = "ssh ${var.vm_config.admin_username}@${module.spoke_vm["spoke2"].public_ip_address} 'ping -c 4 ${module.hub_vm.private_ip_address}'"
  }
}
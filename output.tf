output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

# output "aks_kubeconfig" {
#   description = "Use az cli to fetch credentials: az aks get-credentials -g ${azurerm_resource_group.rg.name} -n ${azurerm_kubernetes_cluster.aks.name}"
#   value       = ""
# }

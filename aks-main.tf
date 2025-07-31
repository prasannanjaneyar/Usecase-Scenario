provider "azurerm" {
  features {}
subscription_id = "5e47e5a1-7dc4-4abb-87a2-f371200842ea"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-demo"
  location            = "East US"
  resource_group_name = "rg-aks-demo"
  dns_prefix          = "aksdemo"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_container_registry" "acr" {
  name                = "containerregi"
  resource_group_name = "acr-rg" # <-- Your existing ACR RG
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

provider "azurerm" {
  features {}
  subscription_id = "5e47e5a1-7dc4-4abb-87a2-f371200842ea"
}
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# ACR
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    environment = "demo"
  }
}

# AKS cluster with managed identity
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.aks_name}-dns"

default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = "demo"
  }

  depends_on = [azurerm_container_registry.acr]
}

# Grant AKS's managed identity pull rights on ACR
data "azurerm_client_config" "current" {}

# Get the principal ID of the AKS system-assigned identity
locals {
  aks_identity_object_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = local.aks_identity_object_id
}


#   default_node_pool {
#     name       = "default"
#     node_count = var.node_count
#     vm_size    = var.node_vm_size
#     os_type    = "Linux"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   # Optional: pin Kubernetes version if provided
#   dynamic "kubernetes_version" {
#     for_each = var.kubernetes_version != null ? [1] : []
#     content {
#       version = var.kubernetes_version
#     }
#   }

#   role_based_access_control {
#     enabled = true
#   }

#   network_profile {
#     network_plugin = "azure"
#   }

# # Grant AKS's managed identity pull rights on ACR
# data "azurerm_client_config" "current" {}

# # Get the principal ID of the AKS system-assigned identity
# locals {
#   aks_identity_object_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "acr_pull" {
#   scope                = azurerm_container_registry.acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = local.aks_identity_object_id
# }

provider "azurerm" {
  features {}
  subscription_id = "5e47e5a1-7dc4-4abb-87a2-f371200842ea"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-demo-flask"
  location = "West Europe"
}

resource "azurerm_service_plan" "asp" {
  name                = "demo-flask-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "cbc-webapp1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false
  }
}

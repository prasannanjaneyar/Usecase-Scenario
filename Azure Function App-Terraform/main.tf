# main.tf
provider "azurerm" {
  features {}
  subscription_id = "5e47e5a1-7dc4-4abb-87a2-f371200842ea"
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = var.environment
  }
}

# Create Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

# Create Blob Container for triggers
resource "azurerm_storage_container" "function_triggers" {
  name                  = "function-triggers"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# Create Application Insights
resource "azurerm_application_insights" "insights" {
  name                = "${var.function_app_name}-insights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  depends_on = [azurerm_resource_group.rg]

  tags = {
    Environment = var.environment
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

# Create Service Bus Namespace (moved before Function App)
resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = var.service_bus_namespace_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

# Create Service Bus Queue
resource "azurerm_servicebus_queue" "sb_queue" {
  name         = var.service_bus_queue_name
  namespace_id = azurerm_servicebus_namespace.sb_namespace.id
  depends_on   = [azurerm_servicebus_namespace.sb_namespace]
}

# Create App Service Plan (Consumption)
resource "azurerm_service_plan" "asp" {
  name                = "${var.function_app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "Y1" # Consumption plan
  depends_on          = [azurerm_resource_group.rg]

  tags = {
    Environment = var.environment
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

# Create Function App with extended timeout
resource "azurerm_windows_function_app" "function_app" {
  name                       = var.function_app_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id
  https_only                 = true
  builtin_logging_enabled    = true
  
  app_settings = {
    "FUNCTIONS_EXTENSION_VERSION"    = "~4"
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
    "FUNCTIONS_WORKER_RUNTIME"       = "dotnet"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
    "AzureWebJobsStorage"            = azurerm_storage_account.storage.primary_connection_string
    "ServiceBusConnection"           = azurerm_servicebus_namespace.sb_namespace.default_primary_connection_string
    "BlobStorageConnection"          = azurerm_storage_account.storage.primary_connection_string
  }

  site_config {
    application_stack {
      dotnet_version = "v6.0"
    }    
    ftps_state = "Disabled"
  }

  depends_on = [
    azurerm_service_plan.asp,
    azurerm_storage_account.storage,
    azurerm_application_insights.insights,
    azurerm_servicebus_namespace.sb_namespace
  ]

  tags = {
    Environment = var.environment
  }

  # Extended timeout for Function App creation
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# Create storage container for function code
resource "azurerm_storage_container" "function_code" {
  name                  = "function-code"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# Create a ZIP deployment package for Function App (assumes you have function code)
data "archive_file" "function_app_package" {
  type        = "zip"
  source_dir  = "${path.module}/Function_code"
  output_path = "${path.module}/function-app.zip"
}

# Upload the function app code
resource "azurerm_storage_blob" "function_app_blob" {
  name                   = "function-app-${filesha256(data.archive_file.function_app_package.output_path)}.zip"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "function-code"
  type                   = "Block"
  source                 = data.archive_file.function_app_package.output_path
  depends_on             = [azurerm_storage_container.function_code]
}

# Update function app settings to use the uploaded code
resource "null_resource" "update_function_app" {
  triggers = {
    code_version = filesha256(data.archive_file.function_app_package.output_path)
  }

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip -g ${azurerm_resource_group.rg.name} -n ${azurerm_windows_function_app.function_app.name} --src ${data.archive_file.function_app_package.output_path}"
  }

  depends_on = [
    azurerm_windows_function_app.function_app,
    azurerm_storage_blob.function_app_blob
  ]
}
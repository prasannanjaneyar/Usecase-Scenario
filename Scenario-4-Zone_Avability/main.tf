provider "azurerm" {
  features {}
  subscription_id = "5e47e5a1-7dc4-4abb-87a2-f371200842ea"
}

resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "example-nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                  = "win-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B2s"
  admin_username        = "azureuser"
  admin_password        = "Password1234!"
  network_interface_ids = [azurerm_network_interface.nic[0].id]
  zone                  = var.zones[0]

  os_disk {
    name                 = "win-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  tags = merge(
    var.default_tags,
    {
      OS   = "Windows"
      Zone = var.zones[0]
    }
  )
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                  = "linux-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  disable_password_authentication = false
  admin_password        = "Password1234!"
  network_interface_ids = [azurerm_network_interface.nic[1].id]
  zone                  = var.zones[1]

  os_disk {
    name                 = "linux-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = merge(
    var.default_tags,
    {
      OS   = "Linux"
      Zone = var.zones[1]
    }
  )
}
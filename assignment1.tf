resource "azurerm_resource_group" "demo-cpg02-01" {
  name     = "rg-demo-cpg02-01-lab"
  location = "eastus2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cpg02-01-lab"
  location            = azurerm_resource_group.demo-cpg02-01.location
  resource_group_name = azurerm_resource_group.demo-cpg02-01.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-cpg02-01-lab"
  resource_group_name  = azurerm_resource_group.demo-cpg02-01.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Since VM module required argument is network interface so we first created the nic using below module

resource "azurerm_network_interface" "example" {
  name                = "nic-cpg02-01-lab"
  location            = azurerm_resource_group.demo-cpg02-01.location
  resource_group_name = azurerm_resource_group.demo-cpg02-01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "win_vm" {
  name                = "win-vm-lab"
  location            = azurerm_resource_group.demo-cpg02-01.location
  resource_group_name = azurerm_resource_group.demo-cpg02-01.name
  size                = "Standard_A2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
resource "azurerm_resource_group" "azurevm1" {
  name     = "azurevm1"
  location = "eastus"
}

# Create virtual network
resource "azurerm_virtual_network" "azure_vnet" {
  name                = "azure-vnet"
  address_space       = ["10.40.0.0/24"]
  location            = azurerm_resource_group.azurevm1.location
  resource_group_name = azurerm_resource_group.azurevm1.name
}

# Create subnet
resource "azurerm_subnet" "azure_subnet" {
  name                 = "azure-subnet"
  resource_group_name  = azurerm_resource_group.azurevm1.name
  virtual_network_name = azurerm_virtual_network.azure_vnet.name
  address_prefixes     = ["10.40.0.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "azure_public_ip" {
  name                = "azure-public-ip"
  location            = azurerm_resource_group.azurevm1.location
  resource_group_name = azurerm_resource_group.azurevm1.name
  allocation_method   = "Dynamic"
}

# Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "azure_nsg" {
  name                = "azure-nsg"
  location            = azurerm_resource_group.azurevm1.location
  resource_group_name = azurerm_resource_group.azurevm1.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "azure_nic" {
  name                = "azure-nic"
  location            = azurerm_resource_group.azurevm1.location
  resource_group_name = azurerm_resource_group.azurevm1.name

  ip_configuration {
    name                          = "azure-ip-configuration"
    subnet_id                     = azurerm_subnet.azure_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg-nic-association" {
  network_interface_id      = azurerm_network_interface.azure_nic.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "azure_storage_account" {
  name                            = "azurestorage15052025"
  location                        = azurerm_resource_group.azurevm1.location
  resource_group_name             = azurerm_resource_group.azurevm1.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "azure_vm1" {
  name                  = "azure-vm1"
  location              = azurerm_resource_group.azurevm1.location
  resource_group_name   = azurerm_resource_group.azurevm1.name
  network_interface_ids = [azurerm_network_interface.azure_nic.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "azure-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  computer_name                   = "azurevm1"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.azure_storage_account.primary_blob_endpoint
  }
}
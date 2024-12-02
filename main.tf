##Provisioning of Azure Virtual Machine && Installation of Nginix via Remote-exec Provisioner

resource "azurerm_resource_group" "rg_laredo" {
    name = "laredo-01-rg"
    location = "UK South"
}

resource "azurerm_virtual_network" "vnet" {
    name  = "laredo-vnet"
    address_space =  ["10.0.0.0/16"]
    location = azurerm_resource_group.rg_laredo.location
    resource_group_name = azurerm_resource_group.rg_laredo.name
}

resource "azurerm_subnet" "subnet" {
    name = "laredo-subnet-1"
    resource_group_name = azurerm_resource_group.rg_laredo.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes =  ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
    name = "laredo-nsg"
    location = azurerm_resource_group.rg_laredo.location
    resource_group_name = azurerm_resource_group.rg_laredo.name

    security_rule {
        name  = "Allow-SSH"
        priority = 1001
        direction ="Inbound"
        access ="Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name  = "Allow-HTTP"
        priority = 1002
        direction ="Inbound"
        access ="Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_public_ip" "public_ip" {
    name = "laredo-public-ip"
    location = azurerm_resource_group.rg_laredo.location
    resource_group_name = azurerm_resource_group.rg_laredo.name
    allocation_method = "Static"
    sku  = "Standard"
}

resource "azurerm_network_interface" "nic" {
    name = "laredo-nic"
    location = azurerm_resource_group.rg_laredo.location
    resource_group_name = azurerm_resource_group.rg_laredo.name

    ip_configuration {
      name = "nic-ip-config"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.public_ip.id
    }
}
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {

    name = "laredo-vm"
    location = azurerm_resource_group.rg_laredo.location
    resource_group_name = azurerm_resource_group.rg_laredo.name

    size = "Standard_DS1_v2"
    disable_password_authentication = "false"

    admin_username = "laredo"
    admin_password = "Laredo@ssword!"

    network_interface_ids =  [azurerm_network_interface.nic.id]

    os_disk {
      caching = "ReadWrite"
      storage_account_type =  "Standard_LRS"
      disk_size_gb = 30
    }

    source_image_reference {
      publisher =  "Canonical"
      offer = "UbuntuServer"
      sku =   "18.04-LTS"
      version = "latest"
    }
    computer_name =  "LAREDO-VM"

    provisioner "remote-exec" {
        inline =  [
            "sudo apt-get install -y nginx",
            "sudo systemctl start nginx"
        ] 
        connection {
            type = "ssh"
            user =  "laredo"
            password = "Laredo@ssword!"
            host = azurerm_public_ip.public_ip.ip_address
        }
    }
}


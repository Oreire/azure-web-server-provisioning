# Provides outputs for the public and private IP addresses of the Virtual Machine

output "private_ip_address" {
  value  = azurerm_network_interface.nic.private_ip_address
}

output "public_ip_address" {
  value  = azurerm_public_ip.public_ip.ip_address
}
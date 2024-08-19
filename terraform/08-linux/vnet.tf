data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

output "vnet_id" {
  value = data.azurerm_virtual_network.vnet.id
}
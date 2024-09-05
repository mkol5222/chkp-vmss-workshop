
#   vnet_name                      =  var.vnet_name #"checkpoint-ha-vnet"
#   vnet_resource_group            =  var.vnet_resource_group # "existing-vnet"

data "azurerm_resource_group" "vnet-rg" {
  name = var.vnet_resource_group
}

resource "azurerm_public_ip" "cluster-vip2" {
  name = "ha-vip2"
  location = data.azurerm_resource_group.vnet-rg.location
  resource_group_name = var.vnet_resource_group
  domain_name_label = "ha-vip2-${random_id.random_id.hex}"
  allocation_method = "Static"
  sku = "Standard"
}

resource "random_id" "random_id" {
  byte_length = 13
  keepers = {
    rg_id = data.azurerm_resource_group.vnet-rg.id
  }
}

output "vip2" {
    value = azurerm_public_ip.cluster-vip2
}

// must be explicit
provider "azurerm" {
  # Configuration options
  features {}
}
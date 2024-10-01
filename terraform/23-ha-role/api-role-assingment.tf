data "azurerm_virtual_machine" "ha1" {
    resource_group_name = "58-ha2"
    name = "ha1"
}

data "azurerm_virtual_machine" "ha2" {
    resource_group_name = "58-ha2"
    name = "ha2"
}

locals {
  ha1_id = data.azurerm_virtual_machine.ha1.identity.0.principal_id
  ha2_id = data.azurerm_virtual_machine.ha2.identity.0.principal_id
}

output "ha1_id"  {
  value = local.ha1_id
}

data "azurerm_resource_group" "vmss1_rg" {
  name = "58-vmss1"
}


output "vmss1_rg_id" {
  value = data.azurerm_resource_group.vmss1_rg.id
}

data "azurerm_role_definition" "virtual_machine_contributor_role_definition" {
  name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "ha1_virtual_machine_contributor_assignment" {

  lifecycle {
    ignore_changes = [
      role_definition_id, principal_id
    ]
  }
  scope = data.azurerm_resource_group.vmss1_rg.id
  role_definition_id = data.azurerm_role_definition.virtual_machine_contributor_role_definition.id
  principal_id = local.ha1_id
}

resource "azurerm_role_assignment" "ha2_virtual_machine_contributor_assignment" {

  lifecycle {
    ignore_changes = [
      role_definition_id, principal_id
    ]
  }
  scope = data.azurerm_resource_group.vmss1_rg.id
  role_definition_id = data.azurerm_role_definition.virtual_machine_contributor_role_definition.id
  principal_id = local.ha2_id
}


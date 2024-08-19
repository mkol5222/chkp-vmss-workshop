

# load from ../sp.yaml

locals {
  spfile = yamldecode(file("../sp.yaml"))
}

# output "sp" {
#   value = local.sp
# }

terraform {
    # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "58-tfbackend"
    storage_account_name = "58tfbackend21745"
    container_name       = "tfstate"
    key                  = "58-vmss1-terraform.tfstate"
  }
}
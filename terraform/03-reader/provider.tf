terraform {
  # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "58-tfbackend"
    storage_account_name = "58tfbackend21745"
    container_name       = "tfstate"
    key                  = "58-reader-terraform.tfstate"
  }

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
  }
}

provider "azuread" {
  # Configuration options
  tenant_id = local.spfile.sp.tenant_id

}

provider "azurerm" {
  # Configuration options
  features {}
}
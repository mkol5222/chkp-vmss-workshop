terraform {
  # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  #   backend "azurerm" {
  #     resource_group_name  = "58-tfbackend"
  #     storage_account_name = "58tfbackend21745"
  #     container_name       = "tfstate"
  #     key                  = "58-reader-terraform.tfstate"
  #   }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.82.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
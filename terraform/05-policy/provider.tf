terraform {
  # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "58-tfbackend"
    storage_account_name = "58tfbackend21745"
    container_name       = "tfstate"
    key                  = "58-policy-terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.82.0"
    }
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      # version = "2.7.0"
    }

  }
}

provider "checkpoint" {

  username = "admin"
  password = "Welcome@Home#1984"
  server   = var.server
  context  = "web_api"
}


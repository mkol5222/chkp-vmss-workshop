
terraform {
  # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "58-tfbackend"
    storage_account_name = "58tfbackend21745"
    container_name       = "tfstate"
    key                  = "58-ha2-tf-terraform.tfstate"
  }
}

module "ha" {
  source = "github.com/mkol5222/cloudGuardIaaS-2024-09-24/terraform/azure/high-availability-existing-vnet"

  client_secret   = local.spfile.sp.client_secret
  client_id       = local.spfile.sp.client_id
  tenant_id       = local.spfile.sp.tenant_id
  subscription_id = local.spfile.sp.subscription_id


  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = "58-ha2"
  cluster_name                   = "ha"
  location                       = "northeurope"

  vnet_name                      =  var.vnet_name #"checkpoint-ha-vnet"
  vnet_resource_group            =  var.vnet_resource_group # "existing-vnet"
  frontend_subnet_name           =  var.frontend_subnet_name # "frontend"
  backend_subnet_name            =  var.backend_subnet_name # "backend"
  frontend_IP_addresses          = [205, 206, 207]
  backend_IP_addresses           = [205, 206, 207]
  admin_password                 = "Welcome@Home#1984"
  smart_1_cloud_token_a          = ""
  smart_1_cloud_token_b          = ""
  sic_key                        = "welcomehome1984"
  vm_size                        = "Standard_D3_v2"
  disk_size                      = "110"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8120"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_type              = "Availability Zone"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  use_public_ip_prefix           = false
  create_public_ip_prefix        = false
  existing_public_ip_prefix_id   = ""
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
  add_storage_account_ip_rules   = false
  storage_account_additional_ips = []
}
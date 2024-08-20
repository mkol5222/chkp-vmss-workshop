
terraform {
    # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "58-tfbackend"
    storage_account_name = "58tfbackend21745"
    container_name       = "tfstate"
    key                  = "58-tf-terraform.tfstate"
  }
}

module "ha" {
  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/high-availability-new-vnet"

  client_secret                  = local.spfile.sp.client_secret
  client_id                      = local.spfile.sp.client_id
  tenant_id                      = local.spfile.sp.tenant_id
  subscription_id                = local.spfile.sp.subscription_id

  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = "58-cpha"
  cluster_name                   = "ha"
  location                       = "westeurope"
  vnet_name                      = "ha-vnet"
  address_space                  = "10.9.0.0/16"
  subnet_prefixes                = ["10.9.1.0/24", "10.9.2.0/24"]
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
  nsg_id                         = ""
  add_storage_account_ip_rules   = false
  storage_account_additional_ips = []
}
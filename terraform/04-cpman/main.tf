

terraform {
    # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "58-tfbackend"
    storage_account_name = "58tfbackend21745"
    container_name       = "tfstate"
    key                  = "58-cpman-terraform.tfstate"
  }
}


# https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/azure/management-existing-vnet
module "cpman" {
    // depends_on = [ azurerm_subnet.cpman_subnet ]
  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/management-new-vnet"
  
  
  
  client_secret                  = local.spfile.sp.client_secret
  client_id                      = local.spfile.sp.client_id
  tenant_id                      = local.spfile.sp.tenant_id
  subscription_id                = local.spfile.sp.subscription_id

source_image_vhd_uri            = "noCustomUri"
resource_group_name             = "58-cpman"
mgmt_name                       = "cpman"
location                        = "westeurope"
vnet_name                       = "cpman"
address_space                   = "10.3.0.0/16"
subnet_prefix                   = "10.3.0.0/24"
management_GUI_client_network   = "0.0.0.0/0"
mgmt_enable_api                 = "all"
admin_password                  = "Welcome@Home#1984"
vm_size                         = "Standard_D3_v2"
disk_size                       = "110"
vm_os_sku                       = "mgmt-byol"
vm_os_offer                     = "check-point-cg-r8120"
os_version                      = "R8120"
bootstrap_script               = "mkdir -p /home/admin/.ssh; curl https://github.com/mkol5222.keys | tee -a /home/admin/.ssh/authorized_keys; chmod 600 /home/admin/.ssh/authorized_keys; chmod 600 /home/admin/.ssh; chown -R admin:admin /home/admin/.ssh" 
allow_upload_download           = true
authentication_type             = "Password"
admin_shell                     = "/bin/bash"
serial_console_password_hash    = ""
maintenance_mode_password_hash  = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
nsg_id                          = ""
add_storage_account_ip_rules    = false
storage_account_additional_ips  = []

  }


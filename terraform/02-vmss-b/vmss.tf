module "vmss" {
   
  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/vmss-new-vnet"

  client_secret                  = local.sp.sp.client_secret
  client_id                      = local.sp.sp.client_id
  tenant_id                      = local.sp.sp.tenant_id
  subscription_id                = local.sp.sp.subscription_id
  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = "58-vmss2"
  location                       = "westeurope"
  vmss_name                      = "vmss2"
  vnet_name                      = "vmss2"
  address_space                  = "10.2.0.0/16"
  subnet_prefixes                = ["10.2.1.0/24", "10.2.2.0/24"]
  backend_lb_IP_address          = 4
  admin_password                 = "Welcome@Home#1984"
  sic_key                        = "welcomehome1984"
  vm_size                        = "Standard_D3_v2"
  disk_size                      = "100"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8120"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_zones_num         = "1"
  minimum_number_of_vm_instances = 2
  maximum_number_of_vm_instances = 10
  management_name                = "mgmt"
  management_IP                  = ""
  management_interface           = "eth0-public"
  configuration_template_name    = "vmss_template"
  notification_email             = ""
  frontend_load_distribution     = "Default"
  backend_load_distribution      = "Default"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  deployment_mode                = "Standard"
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
  nsg_id                         = ""
  add_storage_account_ip_rules   = false
  storage_account_additional_ips = []
}
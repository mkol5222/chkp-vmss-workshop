variable "publish" {
  type        = bool
  default     = false
  description = "Set to true to publish changes"
}

resource "checkpoint_management_publish" "example" {
  count    = var.publish ? 1 : 0
  triggers = ["${timestamp()}"]

  run_publish_on_destroy = true

  depends_on = [
    resource.checkpoint_management_azure_data_center_server.azureDC,
    resource.checkpoint_management_data_center_query.allVMs,
    resource.checkpoint_management_data_center_query.appLinux1,
    resource.checkpoint_management_access_rule.from_dc1_app_linux1,
    resource.checkpoint_management_access_rule.from_net_linux,
    resource.checkpoint_management_access_rule.ha-ssh,
    resource.checkpoint_management_access_rule.ha-from_net_linux,
  ]
}
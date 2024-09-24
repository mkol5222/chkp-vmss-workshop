variable "publish" {
  type        = bool
  default     = false
  description = "Set to true to publish changes"
}

resource "checkpoint_management_publish" "example" {
  count    = var.publish ? 1 : 0
  triggers = ["${timestamp()}"]

  depends_on = [
    checkpoint_management_host.servac, 
    // checkpoint_management_application_site.feed1_site,
  //checkpoint_management_application_site_category.refeed1,
   //checkpoint_management_application_site.refeed1

  ]
}
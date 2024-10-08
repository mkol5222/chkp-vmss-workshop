
locals {
    feed1 = csvdecode(file("${abspath(path.root)}/feed1.csv"))

    refeed1 = csvdecode(file("${abspath(path.root)}/refeed1.csv"))
}


output host1 {
  value       = local.feed1[0].DOMAIN
}

output path1 {
  value       = abspath(path.root)
}

# resource "checkpoint_management_application_site_category" "feed1" {
#   name = "feed1"
#   description = "from feed1.csv"
# }

# resource "checkpoint_management_application_site" "feed1_site" {
#   name = "feed1"
#   primary_category = checkpoint_management_application_site_category.feed1.name
#   description = "domains from feed1.csv"
#   // additional_categories = ["Instant Chat", "Supports Streaming", "New Application Site Category 1",]
#   url_list = local.feed1[*].DOMAIN
#   urls_defined_as_regular_expression = false
# }

# resource "checkpoint_management_application_site_category" "refeed1" {
#   name = "refeed1"
#   description = "from refeed1.csv"
# }

# resource "checkpoint_management_application_site" "refeed1" {
#   name = "refeed1"
#   primary_category = checkpoint_management_application_site_category.refeed1.name
#   description = "domains from refeed1.csv"
#   // url_list = local.refeed1[*].DOMAIN
#   url_list = ["ip\\.iol\\.cz"]
#   urls_defined_as_regular_expression = true
# }

# resource "checkpoint_management_application_site" "ifconfigme" {
#   name = "ifconfigme"
#   primary_category = checkpoint_management_application_site_category.refeed1.name
#   description = "ifconfig.me"
#   // url_list = local.refeed1[*].DOMAIN
#   url_list = ["ifconfig\\.me"]
#   urls_defined_as_regular_expression = true
# }


resource "checkpoint_management_access_layer" "azure" {
  name = "${checkpoint_management_package.package.name} URLF"
  //name = "Azure layer"
  applications_and_url_filtering = true
  firewall = true
  
}

resource "checkpoint_management_package" "package" {
  name   = "Azure"
  access = true

}

resource "checkpoint_management_package" "ha" {
  name   = "HA"
  access = true
}
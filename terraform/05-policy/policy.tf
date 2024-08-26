resource "checkpoint_management_package" "package" {
  name   = "Azure"
  access = true
}

resource "checkpoint_management_package" "ha" {
  name   = "HA"
  access = true
}
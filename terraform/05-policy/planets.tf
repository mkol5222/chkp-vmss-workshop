
resource "checkpoint_management_host" "mars" {
  name = "mars"
  color = "red"
  ipv4_address = "194.4.4.1"
}

resource "checkpoint_management_network" "net_planets" {
  color        = "blue"
  mask_length4 = 16
  name         = "net_planets"
  # nat_settings = {
  #     "auto_rule"   = "true"
  #     "hide_behind" = "gateway"
  #     "install_on"  = "All"
  #     "method"      = "hide"
  # }
  subnet4 = "10.194.0.0"
  tags    = ["made_by_tf", "TF"]
}
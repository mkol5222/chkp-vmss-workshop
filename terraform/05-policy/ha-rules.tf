resource "checkpoint_management_access_rule" "ha-ssh" {
  layer    = "${checkpoint_management_package.ha.name} Network"
  position = { above = checkpoint_management_access_rule.ha-from_net_linux.id }
  #position = { top = "top" }
  name = "allow SSH"

  source = ["Any"]

  enabled = true

  destination        = ["Any"]
  destination_negate = false

  service        = ["ssh"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_rule" "ha-from_net_linux" {
  layer = "${checkpoint_management_package.ha.name} Network"
  //position = { above = checkpoint_management_access_rule.rule900.id }
  position = { top = "top" }
  name     = "from Linux subnet"

  source = [checkpoint_management_network.net-linux.name]

  enabled = true

  destination        = ["Any"]
  destination_negate = false

  service        = ["Any"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}
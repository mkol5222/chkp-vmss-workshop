

# load from ../sp.yaml

locals {
  sp = yamldecode(file("../sp.yaml"))
}

# output "sp" {
#   value = local.sp
# }


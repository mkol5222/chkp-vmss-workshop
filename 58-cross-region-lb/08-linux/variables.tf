variable "vnet_name" {
  description = "The name of the virtual network with VMSS1"
  type        = string
  default     = "vmss1"
}

variable "vnet_rg" {
  description = "The resource group of the virtual network with VMSS1"
  type        = string
  default     = "58-vmss1"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "58-linux"
}

variable "vm_name" {
  description = "The name of the VM"
  type        = string
  default     = "linux"
}

variable "linux-subnet-name" {
  description = "The name of the subnet for the VM"
  type        = string
  default     = "linux-subnet"
  
}
variable "route_through_firewall" {
  description = "Route traffic through a firewall"
  type        = bool
  default     = false
}
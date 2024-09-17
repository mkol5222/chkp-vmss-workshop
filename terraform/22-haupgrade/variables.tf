variable "vnet_name" {
    type = string
    default = "vmss1"
}

variable "vnet_resource_group" {
    type = string
    default = "58-vmss1"
}

variable "frontend_subnet_name" {
    type = string
    default = "Frontend"
}

variable "backend_subnet_name" {
    type = string
    default = "Backend"
}

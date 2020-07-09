variable "subnet_name" {
    type =string
    default ="mySubnet"
}

variable "subnet_rg_name" {
    type = string
    default = "eastus"
}

variable "subnet_vnet_name" {
    type = string
}

variable "subnet_address_prefixes" {
    type = list
    #default =["10.0.1.0/24"]
}
variable "vnet_name"{
    type = string
    default = "myVnet"
}

variable "vnet_location"{
    type = string
    default ="eastus"
}
variable "vnet_rg_name"{
    type = string 
}
variable "vnet_address_space"{
    type = list
    #default =["10.0.0.0/16"]
}
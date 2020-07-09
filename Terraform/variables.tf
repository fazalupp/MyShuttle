variable "rg_name"{
  type = string
}

variable "rg_location"{
  type =string
}

variable "vnet_name"{
    type = string
}

variable "vnet_location"{
    type = string
}

variable "vnet_address_space"{
  type = list
}

variable "subnet_name"{
  type = string
}

variable "subnet_address_prefixes"{
  type = list
}

variable "publicIp_name"{
  type = string
}

variable "publicIp_location" {
  type = string
}

variable "nsg_name" {
  type =string
}

variable "nsg_location"{
  type =string
}

variable "nic_name"{
  type =string
}

variable "nic_location"{
  type =string
}

variable "sql_server_name" {
    type = string
    default = "myshuttleserver20001"
}

variable "app_service_plan_name" {
    type = string
    default = "MyPlan"
}

variable "app_service_name" {
    type = string
    default = "MyShuttleApp20001"
}

variable "app_service_slot_name" {
    type = string
    default = "dev"
}
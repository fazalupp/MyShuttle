# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = var.nic_name
    location                  = var.nic_location
    resource_group_name       = var.nic_rg_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = var.nic_subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = var.nic_publicIp_address_id
    }

    tags = {
        environment = "Terraform Demo"
    }
}
# Create Security Rule -SSH
resource "azurerm_network_security_rule" "myterraformsecurityruleforSSH" {
    name                        = "SSH"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = var.ssh_rg_name
    network_security_group_name = var.ssh_nsg_name
}
resource "azurerm_network_security_rule" "myterraformsecurityruleforHttp" {
    name                        =  "allow-http"
    priority                    =  110
    direction                   =  "Inbound"
    access                      =  "Allow"
    protocol                    =  "Tcp"
    source_port_range           =  "*"
    destination_port_range      =  "80"
    source_address_prefix       =  "Internet"
    destination_address_prefix  =  "*"
    resource_group_name         = var.rule_rg_name           
    network_security_group_name = var.rule_nsg_name
}
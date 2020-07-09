# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = var.subnet_name
    resource_group_name  = var.subnet_rg_name
    virtual_network_name = var.subnet_vnet_name
    address_prefixes       = var.subnet_address_prefixes
}
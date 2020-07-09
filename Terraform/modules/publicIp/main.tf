# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = var.publicIp_name
    location                     = var.publicIp_location
    resource_group_name          = var.publicIp_rg_name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}
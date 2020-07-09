# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = var.rg_name
    location = var.rg_location

    tags = {
        environment = "Terraform Demo"
    }
}

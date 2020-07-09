# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"

    # subscription_id = "5e022117-1c3d-4e96-a5c2-bcce0cb09a2d"
    # client_id       = "e986482e-7b1b-4daa-b132-4d75b6c9bad7"
    # client_secret   = "ZJB2SA_HTWx6aN-eh_VQCslV4T_S38yunz"
    # tenant_id       = "687f51c3-0c5d-4905-84f8-97c683a5b9d1"
    
    features {}
}
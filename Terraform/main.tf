# Create a resource group if it doesn't exist
module "resourceGroup" {
  source = ".//modules/resourceGroup"
  rg_name = var.rg_name
  rg_location =var.rg_location
}

# Create virtual network
module "virtualNetwork" {
    source = ".//modules/virtualNetwork"
    vnet_name = var.vnet_name
    vnet_location = var.vnet_location
    vnet_rg_name = module.resourceGroup.name
    vnet_address_space = var.vnet_address_space
}

# Create subnet
module "subnet" {
    source = ".//modules/subnet"
    subnet_name = var.subnet_name
    subnet_rg_name  = module.resourceGroup.name
    subnet_vnet_name = module.virtualNetwork.name
    subnet_address_prefixes = var.subnet_address_prefixes
}

# Create public IPs
module "publicIp" {
    source = ".//modules/publicIp"
    publicIp_name = var.publicIp_name
    publicIp_location = var.publicIp_location
    publicIp_rg_name  = module.resourceGroup.name
}

# Create Network Security Group and rule
module "networkSecurityGroup" {
    source = ".//modules/networkSecurityGroup"
    nsg_name = var.nsg_name
    nsg_location = var.nsg_location
    nsg_rg_name = module.resourceGroup.name
}
# Create Security Rule -SSH
module "securityRuleSSH" {
    source = ".//modules/securityRuleSSH"
    ssh_rg_name         = module.resourceGroup.name
    ssh_nsg_name        = module.networkSecurityGroup.name
}

# Create Security Rule -Http
module "securityRule" {
    source = ".//modules/securityRule"
    rule_rg_name         = module.resourceGroup.name
    rule_nsg_name        = module.networkSecurityGroup.name
}

# Create network interface
module "networkInterface" {
    source = ".//modules/networkInterface"
    nic_name  = var.nic_name
    nic_location = var.nic_location
    nic_rg_name = module.resourceGroup.name
    nic_subnet_id = module.subnet.id
    nic_publicIp_address_id = module.publicIp.id

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = module.networkInterface.id
    network_security_group_id = module.networkSecurityGroup.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = module.resourceGroup.name
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = module.resourceGroup.name
    location                    = "westus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}
# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "westus"
    resource_group_name   = module.resourceGroup.name
    network_interface_ids = [module.networkInterface.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    admin_password = "azureuser#123"
    disable_password_authentication = false
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
    
}

resource "azurerm_app_service_plan" "javasql" {
  name                = var.app_service_plan_name
  location            = var.rg_location
  resource_group_name = module.resourceGroup.name

    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "javasql" {
  name                = var.app_service_name
  location            = var.rg_location
  resource_group_name = module.resourceGroup.name
  app_service_plan_id = azurerm_app_service_plan.javasql.id
  
  site_config {
    java_version            = "1.8"
    java_container          = "TOMCAT"
    java_container_version  = "9.0"
  }

  connection_string {
    name  = "MyShuttleDb"
    type  = "MySQL"
    value = "__connectionstringvalue__"
  }
}

resource "azurerm_app_service_slot" "javasql" {
  name                = var.app_service_slot_name
  app_service_name    = azurerm_app_service.javasql.name
  location            = var.rg_location
  resource_group_name = module.resourceGroup.name
  app_service_plan_id = azurerm_app_service_plan.javasql.id
  
  site_config {
    java_version            = "1.8"
    java_container          = "TOMCAT"
    java_container_version  = "9.0"
  }

  connection_string {
    name  = "MyShuttleDb"
    type  = "MySQL"
    value = "__connectionstringvalue__"
  }
}

resource "azurerm_mysql_server" "javasql" {
  name                = var.sql_server_name
  location            = var.rg_location
  resource_group_name = module.resourceGroup.name

  administrator_login          = "__sqlserverlogin__"
  administrator_login_password = "__serverpassword__"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"
  ssl_enforcement_enabled           = false
}

resource "azurerm_mysql_firewall_rule" "javasql" {
  name                = "AzureServicesAllow"
  resource_group_name = module.resourceGroup.name
  server_name         = azurerm_mysql_server.javasql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("user-data.sh")
}

data "azurerm_public_ip" "nginxIp" {
  name                = module.publicIp.name
  resource_group_name = module.resourceGroup.name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.nginxIp.ip_address
}

output "ResorceGroupCreatedAs"{
  value= module.resourceGroup.name
}
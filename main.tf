########################
# WebGIS - General Use #
########################


########################
### Common Resources ###
########################

provider "azurerm" {
  subscription_id = "${var.AzureCredentials["Subscription_ID"]}"
  client_id       = "${var.AzureCredentials["Client_ID"]}"
  client_secret   = "${var.AzureCredentials["Client_Secret"]}"
  tenant_id       = "${var.AzureCredentials["Tenant_ID"]}"
}


#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

#DNS Zone
resource "azurerm_dns_zone" "DNSZone" {
  name                = "esriemcs.com"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

#######################
#Networking components
#######################
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"  
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_servers         = "${var.dns_servers}"
}

resource "azurerm_subnet" "PrivateSubnet" {
  name                 = "PrivateSubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.subnet_prefixes["PrivateSubnetPrefix"]}"
  network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"
}

resource "azurerm_network_security_group" "network_security_group" {
  name                  = "${var.prefix}-nsg" 
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "security_rule_rdp" {
  name                        = "rdp"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.network_security_group.name}"
}

###############################
####ArcGIS Server Resources####
###############################

#ArcGIS Server NIC
resource "azurerm_network_interface" "ArcGIS_Server_NIC" {
  name                = "${var.prefix}-ArcGIS_Server_NIC"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.prefix}-ArcGIS_Server_IP"
    subnet_id                     = "${azurerm_subnet.PrivateSubnet.id}"    
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "ArcGIS_Server" {
  name                  = "${var.prefix}-ArcGIS_Server"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ArcGIS_Server_NIC.id}"]
  vm_size               = "${var.ArcGIS_Server_Specs["ServerType"]}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.ArcGIS_Server_Specs["Image_Publisher"]}"
    offer     = "${var.ArcGIS_Server_Specs["Image_Offer"]}"
    sku       = "${var.ArcGIS_Server_Specs["Image_sku"]}"
    version   = "${var.ArcGIS_Server_Specs["Image_Version"]}"
  }

  storage_os_disk {
    name              = "${var.prefix}-ArcGIS_Server_OSDisk"
    managed_disk_type = "${var.ArcGIS_Server_Specs["OS_Disk_Type"]}"
    caching           = "${var.ArcGIS_Server_Specs["OS_Disk_Caching"]}"
    create_option     = "${var.ArcGIS_Server_Specs["OS_Disk_Create_option"]}"
  }

  os_profile {
    computer_name  = "${var.ArcGIS_Server_Specs["Computer_Name"]}"
    admin_username = "${var.ArcGIS_Server_Specs["Admin_Username"]}"
    admin_password = "${var.ArcGIS_Server_Specs["Admin_Password"]}"
  }


  storage_data_disk {
    name              = "${var.prefix}-ArcGIS_Server_DataDisk"
    managed_disk_type = "${var.ArcGIS_Server_Specs["Data_Disk_Type"]}"
    caching           = "${var.ArcGIS_Server_Specs["Data_Disk_Caching"]}"
    create_option     = "${var.ArcGIS_Server_Specs["Data_Disk_Create_Option"]}"
    disk_size_gb      = "${var.ArcGIS_Server_Specs["Data_Disk_Disk_Size"]}"
    lun               = "${var.ArcGIS_Server_Specs["Data_Disk_Disk_Lun"]}"

  }

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

}

###############################
####Portal Server Resources####
###############################
#Portal Server NIC
resource "azurerm_network_interface" "Portal_Server_NIC" {
  name                = "${var.prefix}-Portal_Server_NIC"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.prefix}-Portal_Server_IP"
    subnet_id                     = "${azurerm_subnet.PrivateSubnet.id}"    
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "Portal_Server" {
  name                  = "${var.prefix}-Portal_Server"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.Portal_Server_NIC.id}"]
  vm_size               = "${var.Portal_Server_Specs["ServerType"]}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.Portal_Server_Specs["Image_Publisher"]}"
    offer     = "${var.Portal_Server_Specs["Image_Offer"]}"
    sku       = "${var.Portal_Server_Specs["Image_sku"]}"
    version   = "${var.Portal_Server_Specs["Image_Version"]}"
  }

  storage_os_disk {
    name              = "${var.prefix}-Portal_Server_OSDisk"
    managed_disk_type = "${var.Portal_Server_Specs["OS_Disk_Type"]}"
    caching           = "${var.Portal_Server_Specs["OS_Disk_Caching"]}"
    create_option     = "${var.Portal_Server_Specs["OS_Disk_Create_option"]}"
  }

  os_profile {
    computer_name  = "${var.Portal_Server_Specs["Computer_Name"]}"
    admin_username = "${var.Portal_Server_Specs["Admin_Username"]}"
    admin_password = "${var.Portal_Server_Specs["Admin_Password"]}"
  }


  storage_data_disk {
    name              = "${var.prefix}-Portal_Server_DataDisk"
    managed_disk_type = "${var.Portal_Server_Specs["Data_Disk_Type"]}"
    caching           = "${var.Portal_Server_Specs["Data_Disk_Caching"]}"
    create_option     = "${var.Portal_Server_Specs["Data_Disk_Create_Option"]}"
    disk_size_gb      = "${var.Portal_Server_Specs["Data_Disk_Disk_Size"]}"
    lun               = "${var.Portal_Server_Specs["Data_Disk_Disk_Lun"]}"

  }

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }
}

#######################################
####ArcGIS Monitor Server Resources####
#######################################

#ArcGIS Monitor Server NIC
resource "azurerm_network_interface" "ArcGIS_Monitor_Server_NIC" {
  name                = "${var.prefix}-ArcGIS_Monitor_Server_NIC"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.prefix}-ArcGIS_Monitor_Server_IP"
    subnet_id                     = "${azurerm_subnet.PrivateSubnet.id}"    
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "ArcGIS_Monitor_Server" {
  name                  = "${var.prefix}-ArcGIS_Monitor_Server"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ArcGIS_Monitor_Server_NIC.id}"]
  vm_size               = "${var.ArcGIS_Monitor_Server_Specs["ServerType"]}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.ArcGIS_Monitor_Server_Specs["Image_Publisher"]}"
    offer     = "${var.ArcGIS_Monitor_Server_Specs["Image_Offer"]}"
    sku       = "${var.ArcGIS_Monitor_Server_Specs["Image_sku"]}"
    version   = "${var.ArcGIS_Monitor_Server_Specs["Image_Version"]}"
  }

  storage_os_disk {
    name              = "${var.prefix}-ArcGIS_Monitor_Server_OSDisk"
    managed_disk_type = "${var.ArcGIS_Monitor_Server_Specs["OS_Disk_Type"]}"
    caching           = "${var.ArcGIS_Monitor_Server_Specs["OS_Disk_Caching"]}"
    create_option     = "${var.ArcGIS_Monitor_Server_Specs["OS_Disk_Create_option"]}"
  }

  os_profile {
    computer_name  = "${var.ArcGIS_Monitor_Server_Specs["Computer_Name"]}"
    admin_username = "${var.ArcGIS_Monitor_Server_Specs["Admin_Username"]}"
    admin_password = "${var.ArcGIS_Monitor_Server_Specs["Admin_Password"]}"
  }


  storage_data_disk {
    name              = "${var.prefix}-ArcGIS_Monitor_Server_DataDisk"
    managed_disk_type = "${var.ArcGIS_Monitor_Server_Specs["Data_Disk_Type"]}"
    caching           = "${var.ArcGIS_Monitor_Server_Specs["Data_Disk_Caching"]}"
    create_option     = "${var.ArcGIS_Monitor_Server_Specs["Data_Disk_Create_Option"]}"
    disk_size_gb      = "${var.ArcGIS_Monitor_Server_Specs["Data_Disk_Disk_Size"]}"
    lun               = "${var.ArcGIS_Monitor_Server_Specs["Data_Disk_Disk_Lun"]}"

  }

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

}

###################################
####Data Store Server Resources####
###################################

#Data Store  Server NIC
resource "azurerm_network_interface" "Data_Store_Server_NIC" {
  name                = "${var.prefix}-Data_Store_Server_NIC"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.prefix}-Data_Store_Server_IP"
    subnet_id                     = "${azurerm_subnet.PrivateSubnet.id}"    
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "Data_Store_Server" {
  name                  = "${var.prefix}-Data_Store_Server"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.Data_Store_Server_NIC.id}"]
  vm_size               = "${var.Data_Store_Server_Specs["ServerType"]}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.Data_Store_Server_Specs["Image_Publisher"]}"
    offer     = "${var.Data_Store_Server_Specs["Image_Offer"]}"
    sku       = "${var.Data_Store_Server_Specs["Image_sku"]}"
    version   = "${var.Data_Store_Server_Specs["Image_Version"]}"
  }

  storage_os_disk {
    name              = "${var.prefix}-Data_Store_Server_OSDisk"
    managed_disk_type = "${var.Data_Store_Server_Specs["OS_Disk_Type"]}"
    caching           = "${var.Data_Store_Server_Specs["OS_Disk_Caching"]}"
    create_option     = "${var.Data_Store_Server_Specs["OS_Disk_Create_option"]}"
  }

  os_profile {
    computer_name  = "${var.Data_Store_Server_Specs["Computer_Name"]}"
    admin_username = "${var.Data_Store_Server_Specs["Admin_Username"]}"
    admin_password = "${var.Data_Store_Server_Specs["Admin_Password"]}"
  }


  storage_data_disk {
    name              = "${var.prefix}-Data_Store_Server_DataDisk"
    managed_disk_type = "${var.Data_Store_Server_Specs["Data_Disk_Type"]}"
    caching           = "${var.Data_Store_Server_Specs["Data_Disk_Caching"]}"
    create_option     = "${var.Data_Store_Server_Specs["Data_Disk_Create_Option"]}"
    disk_size_gb      = "${var.Data_Store_Server_Specs["Data_Disk_Disk_Size"]}"
    lun               = "${var.Data_Store_Server_Specs["Data_Disk_Disk_Lun"]}"

  }

  os_profile_windows_config {
    provision_vm_agent  = "true"
  }

}

#######################
##Application Gateway##
#######################

resource "azurerm_public_ip" "GWPublicIP" {
    name                          = "${var.prefix}-GWPublicIP"
    location                      = "${var.location}"
    resource_group_name           = "${azurerm_resource_group.rg.name}"
    public_ip_address_allocation  = "dynamic"
}

resource "azurerm_subnet" "PublicAppGwSubnet" {
  name                 = "PublicAppGwSubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.subnet_prefixes["AppGwSubnetPrefix"]}"
}

resource "azurerm_application_gateway" "gateway" {
  name                  = "${var.prefix}-Application_Gateway"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"

  sku {
    name           = "Standard_Small"
    tier           = "Standard"
    capacity       = 1
  }

  gateway_ip_configuration {
      name         = "my-gateway-ip-configuration"
      subnet_id    = "${azurerm_virtual_network.vnet.id}/subnets/${azurerm_subnet.PublicAppGwSubnet.name}"
  }

  frontend_port {
      name         = "FrontEndPort"
      port         = 80
  }

  frontend_ip_configuration {
      name         = "FrontEndIP"  
      public_ip_address_id = "${azurerm_public_ip.GWPublicIP.id}"
  }

  backend_address_pool {
      name              = "BackendPoolArcGISServers"
      ip_address_list   = ["${azurerm_network_interface.ArcGIS_Server_NIC.private_ip_address}"]
  }

  backend_address_pool {
      name              = "BackendPoolPortalServers"
      ip_address_list   = ["${azurerm_network_interface.Portal_Server_NIC.private_ip_address}"]
  }

  backend_http_settings {
      name                  = "BackendHTTPSettingPortalServers"
      cookie_based_affinity = "Disabled"
      port                  = 7443
      protocol              = "Http"
     request_timeout        = 20
  }

  backend_http_settings {
    name                  = "BackendHTTPSettingArcGISServers"
    cookie_based_affinity = "Disabled"
    port                  = 6443
    protocol              = "Http"
    request_timeout        = 20
  }

  http_listener {
    name                                  = "HTTPListener"
    frontend_ip_configuration_name        = "FrontEndIP"
    frontend_port_name                    = "FrontEndPort"
    protocol                              = "Http"
  }

  url_path_map {
    name                                = "PathBasedRoutingRulePathMap"
    default_backend_address_pool_name   = "BackendPoolPortalServers" 
    default_backend_http_settings_name  = "BackendHTTPSettingPortalServers"

    path_rule {
      name                          = "PortalServerPath"
      backend_address_pool_name     = "BackendPoolPortalServers"
      backend_http_settings_name    = "BackendHTTPSettingPortalServers"
      paths = [
        "/portal",
      ]
    }

    path_rule {
      name                          = "ArcGISServerPath"
      backend_address_pool_name     = "BackendPoolArcGISServers"
      backend_http_settings_name    = "BackendHTTPSettingArcGISServers"
      paths = [
        "/arcgis",
      ]
    }
  }

  request_routing_rule {
    name                       = "PathBasedRoutingRule"
    rule_type                  = "PathBasedRouting"
    http_listener_name         = "HTTPListener"
    url_path_map_name          = "PathBasedRoutingRulePathMap"
  }
}
variable "AzureCredentials" {
  description = "Credentials to log in to Azure"
  default = {
    "Subscription_ID"   = "fff7e1c3-c179-4d20-b449-d68892115292"
    "Client_ID"         = "d4562d4b-80c4-4912-880d-58ad28941b80"
    "Client_Secret"     = "5hpJHAtO+tjBgn6vNQY2GIl4sFMEidJjTBiHXoNa8eU="
    "Tenant_ID"         = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  }
}

variable "prefix" {
  description = "Default prefix to use with your resource names. This can be the customer name"
  default = "Chevron"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default="westus2"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet"
  default     = []
}

variable "subnet_prefixes" {
  description = "Subnet prefixes for all subnets"
  default = {
    "PrivateSubnetPrefix"           = "10.0.1.0/24"
    "EMCSBastionSubnetPrefix"       = "10.0.2.0/24"
    "CustomerBastionSubnetPrefix"   = "10.0.3.0/24"
    "AppGwSubnetPrefix"             = "10.0.4.0/24"
    "WAFSubnetPrefix"               = "10.0.5.0/24"
  }
}

#ArcGIS Server settings
variable "ArcGIS_Server_Specs" {
  description = "Specs for ArcGIS Server"
  default = {
    "ServerType"                  = "Standard_E4s_v3"
    "Image_Publisher"             = "MicrosoftWindowsServer"
    "Image_Offer"                 = "WindowsServer"
    "Image_sku"                   = "2012-R2-Datacenter"
    "Image_Version"               = "latest"

    "OS_Disk_Type"                = "Standard_LRS"
    "OS_Disk_Caching"             = "ReadWrite"
    "OS_Disk_Create_option"       = "FromImage"

    
    "Data_Disk_Type"              = "Standard_LRS"
    "Data_Disk_Caching"           = "ReadWrite"
    "Data_Disk_Create_Option"     = "Empty"
    "Data_Disk_Disk_Size"         = "128"
    "Data_Disk_Disk_Lun"          = "0"

    "Computer_Name"               = "ArcGIServer"
    "Admin_Username"              = "ESRIAdmin"
    "Admin_Password"              = "Password@123"

  }
}

#Portal Server settings
variable "Portal_Server_Specs" {
  description = "Specs for Portal Server"
  default = {
    "ServerType"                  = "Standard_DS12_v2"
    "Image_Publisher"             = "MicrosoftWindowsServer"
    "Image_Offer"                 = "WindowsServer"
    "Image_sku"                   = "2012-R2-Datacenter"
    "Image_Version"               = "latest"

    "OS_Disk_Type"                = "Standard_LRS"
    "OS_Disk_Caching"             = "ReadWrite"
    "OS_Disk_Create_option"       = "FromImage"

    
    "Data_Disk_Type"              = "Standard_LRS"
    "Data_Disk_Caching"           = "ReadWrite"
    "Data_Disk_Create_Option"     = "Empty"
    "Data_Disk_Disk_Size"         = "128"
    "Data_Disk_Disk_Lun"          = "0"

    "Computer_Name"               = "PortalServer"
    "Admin_Username"              = "ESRIAdmin"
    "Admin_Password"              = "Password@123"
  }
}

# ArcGIS Monitor Server settings
variable "ArcGIS_Monitor_Server_Specs" {
  description = "Specs for ArcGIS Monitor Server"
  default = {
    "ServerType"                  = "Standard_DS11_v2"
    "Image_Publisher"             = "MicrosoftWindowsServer"
    "Image_Offer"                 = "WindowsServer"
    "Image_sku"                   = "2012-R2-Datacenter"
    "Image_Version"               = "latest"

    "OS_Disk_Type"                = "Standard_LRS"
    "OS_Disk_Caching"             = "ReadWrite"
    "OS_Disk_Create_option"       = "FromImage"

    
    "Data_Disk_Type"              = "Standard_LRS"
    "Data_Disk_Caching"           = "ReadWrite"
    "Data_Disk_Create_Option"     = "Empty"
    "Data_Disk_Disk_Size"         = "128"
    "Data_Disk_Disk_Lun"          = "0"

    "Computer_Name"               = "MonitorServer"
    "Admin_Username"              = "ESRIAdmin"
    "Admin_Password"              = "Password@123"
  }
}

# Relational Data Store Server settings
variable "Data_Store_Server_Specs" {
  description = "Specs for Relational Data Store Server"
  default = {
    "ServerType"                  = "Standard_DS12_v2"
    "Image_Publisher"             = "MicrosoftWindowsServer"
    "Image_Offer"                 = "WindowsServer"
    "Image_sku"                   = "2012-R2-Datacenter"
    "Image_Version"               = "latest"

    "OS_Disk_Type"                = "Standard_LRS"
    "OS_Disk_Caching"             = "ReadWrite"
    "OS_Disk_Create_option"       = "FromImage"

    
    "Data_Disk_Type"              = "Standard_LRS"
    "Data_Disk_Caching"           = "ReadWrite"
    "Data_Disk_Create_Option"     = "Empty"
    "Data_Disk_Disk_Size"         = "128"
    "Data_Disk_Disk_Lun"          = "0"

    "Computer_Name"               = "DataStoreServer"
    "Admin_Username"              = "ESRIAdmin"
    "Admin_Password"              = "Password@123"
  }
}

#Application Gateway Settings
variable "app_gateway_settings" {
  description = "Specs for Relational Data Store Server"
  default = {
    "sku_Name"            = ""
    "sku_tier"             = ""
    "sku_"                 = ""
    ""                   = ""
    ""               = ""

  }
}



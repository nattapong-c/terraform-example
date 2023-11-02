resource "azurerm_network_security_group" "network" {
  name                = local.name_network_security
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowVnetInBound80"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowVnetInBound443"
    priority                   = 121
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_virtual_network" "network" {
  name                = local.name_network
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = var.address_space
  tags = {
    "project" = local.project
    "product" = local.tag_product
    "platform" = local.tag_platform
    "module"  = local.tag_module
    "owner"   = local.tag_owner
    "stage"   = var.stage
  }
}
resource "azurerm_subnet" "kubesubnet" {
  name                 = local.subnet_kube
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [var.address_prefixes_aks]

  depends_on = [
    azurerm_virtual_network.network
  ]
}

resource "azurerm_subnet_network_security_group_association" "network" {
  subnet_id                 = azurerm_subnet.kubesubnet.id
  network_security_group_id = azurerm_network_security_group.network.id
}

resource "azurerm_public_ip" "network" {
  name                = local.name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    "project" = local.project
    "product" = local.tag_product
    "platform" = local.tag_platform
    "module"  = local.tag_module
    "owner"   = local.tag_owner
    "stage"   = var.stage
  }
}


resource "azurerm_dns_a_record" "network_frontend" {
  name                = var.dns_a_record_frontend
  zone_name           = data.azurerm_dns_zone.network.name
  resource_group_name = data.azurerm_dns_zone.network.resource_group_name
  ttl                 = 3600
  records             = ["${azurerm_public_ip.network.ip_address}"]
  depends_on = [
    azurerm_public_ip.network
  ]
}


resource "azurerm_dns_a_record" "network_backend" {
  name                = var.dns_a_record_backend
  zone_name           = data.azurerm_dns_zone.network.name
  resource_group_name = data.azurerm_dns_zone.network.resource_group_name
  ttl                 = 3600
  records             = ["${azurerm_public_ip.network.ip_address}"]
  depends_on = [
    azurerm_public_ip.network
  ]
}


resource "azurerm_dns_a_record" "network_composer" {
  name                = var.dns_a_record_composer
  zone_name           = data.azurerm_dns_zone.network.name
  resource_group_name = data.azurerm_dns_zone.network.resource_group_name
  ttl                 = 3600
  records             = ["${azurerm_public_ip.network.ip_address}"]
  depends_on = [
    azurerm_public_ip.network
  ]
}

resource "azurerm_dns_a_record" "network_auth" {
  name                = var.dns_a_record_auth
  zone_name           = data.azurerm_dns_zone.network.name
  resource_group_name = data.azurerm_dns_zone.network.resource_group_name
  ttl                 = 3600
  records             = ["${azurerm_public_ip.network.ip_address}"]
  depends_on = [
    azurerm_public_ip.network
  ]
}

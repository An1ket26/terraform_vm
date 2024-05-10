resource "azurerm_virtual_network" "vnet1" {
  name                = local.vnet_name
  resource_group_name = local.resource_group_name
  location            = local.resource_grp_location
  address_space       = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "appgatewaysubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.4.0/24"]
}

resource "azurerm_public_ip" "public_ip_app_gateway" {
  name                = "gateway-pip"
  resource_group_name = local.resource_group_name
  location            = local.resource_grp_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public_ip_load_balancer" {
  name                = "lb-pip"
  resource_group_name = local.resource_group_name
  location            = local.resource_grp_location
  allocation_method   = "Dynamic"
}


resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  resource_group_name = local.resource_group_name
  location            = local.resource_grp_location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip_app_gateway.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_lb" "internal_load_balancer" {
  name                = "bkLoadBalancer"
  location            = local.resource_grp_location
  resource_group_name = local.resource_group_name

  sku = "Standard"

  frontend_ip_configuration {
    name="publicipaddress"
    subnet_id = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_lb_backend_address_pool" "internal_load_balancer_backend_pool" {
  loadbalancer_id = azurerm_lb.internal_load_balancer.id
  name            = "BackEndAddressPool"
}
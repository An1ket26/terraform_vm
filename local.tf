locals {
  frontend_vm_name               = "${var.environment}${var.frontend_vm_name}"
  backend_vm_name                = "${var.environment}${var.backend_vm_name}"
  resource_group_name            = azurerm_resource_group.rg1.name
  resource_grp_location          = azurerm_resource_group.rg1.location
  vnet_name                      = var.vnet_name
  backend_address_pool_name      = "${azurerm_virtual_network.vnet1.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet1.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet1.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet1.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet1.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet1.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet1.name}-rdrcfg"
}

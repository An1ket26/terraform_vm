resource "azurerm_public_ip" "bastionpip" {
  name                = "bastionpip"
  resource_group_name = local.resource_group_name
  location            = local.resource_grp_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "bastion1"
  location            = local.resource_grp_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}
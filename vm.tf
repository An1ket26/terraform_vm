resource "azurerm_windows_virtual_machine_scale_set" "vm_frontend" {
  name                 = local.frontend_vm_name
  location             = local.resource_grp_location
  resource_group_name  = local.resource_group_name
  sku                  = "Standard_F2"
  admin_username       = "aniket"
  admin_password       = "P@ssword1234"
  instances            = 1
  computer_name_prefix = "aniket"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  network_interface {
    name    = "frontendnic"
    primary = true

    ip_configuration {
      name                                         = "frontendip"
      primary                                      = true
      subnet_id                                    = azurerm_subnet.subnet1.id
      application_gateway_backend_address_pool_ids = [tolist(azurerm_application_gateway.app_gateway.backend_address_pool).0.id]
    }
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}


resource "azurerm_windows_virtual_machine_scale_set" "vm_backend" {
  name                 = local.backend_vm_name
  location             = local.resource_grp_location
  resource_group_name  = local.resource_group_name
  sku                  = "Standard_F2"
  admin_username       = "aniket"
  admin_password       = "P@ssword1234"
  instances            = 1
  computer_name_prefix = "aniket"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  network_interface {
    name    = "backendnic"
    primary = true

    ip_configuration {
      name                                   = "backendip"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.internal_load_balancer_backend_pool.id]
    }
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}
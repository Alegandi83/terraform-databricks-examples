resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.deploy_id}-${var.deploy_env}-${var.component_name}-${var.deploy_ver}"
  location            = var.location
  resource_group_name = local.rg_name
  address_space       = [var.spoke_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.deploy_id}-${var.deploy_env}-${var.component_name}-${var.deploy_ver}"
  location            = var.location
  resource_group_name = local.rg_name
  tags                = var.tags
}


resource "azurerm_route_table" "this" {
  name                = "rt-${var.deploy_id}-${var.deploy_env}-${var.component_name}-${var.deploy_ver}"
  location            = var.location
  resource_group_name = local.rg_name
  tags                = var.tags
}

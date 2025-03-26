resource "azurerm_storage_account" "ext_storage" {
  name                     = var.landing_external_location_name
  location                 = var.location
  resource_group_name      = var.landing_adls_rg
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "ext_storage_container" {
  depends_on             = [azurerm_storage_account.ext_storage]
  name                   = "con"
  storage_account_id     = azurerm_storage_account.ext_storage.id
  container_access_type  = "private"
}

resource "azurerm_role_assignment" "ext_storage_assignment" {
  depends_on           = [azurerm_storage_container.ext_storage_container]
  scope                = azurerm_storage_account.ext_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.access_connector_id
}
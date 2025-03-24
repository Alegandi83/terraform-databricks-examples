resource "azurerm_databricks_access_connector" "access_connector" {
  name                = "dac-${var.deploy_id}-${var.deploy_env}-${var.deploy_prj}-${var.component_name}-${var.deploy_ver}"
  resource_group_name = local.rg_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_storage_account" "dls" {
  depends_on             = [azurerm_databricks_access_connector.access_connector]
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = local.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "dls_container" {
  depends_on             = [azurerm_storage_account.dls]
  name                   = "con"
  storage_account_id     = azurerm_storage_account.dls.id
  container_access_type  = "private"
}

resource "azurerm_role_assignment" "dls_contributor" {
  depends_on           = [azurerm_storage_container.dls_container]
  scope                = azurerm_storage_account.dls.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.access_connector.identity[0].principal_id
}
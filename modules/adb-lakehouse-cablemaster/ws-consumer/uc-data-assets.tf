resource "databricks_catalog" "bronze-catalog" {
  metastore_id  = var.metastore_id
  name          = "bronze_catalog"
  comment       = "this catalog is for the bronze layer"
  force_destroy = true
}

resource "databricks_schema" "bronze_source1-schema" {
  depends_on    = [databricks_catalog.bronze-catalog]
  catalog_name  = databricks_catalog.bronze-catalog.name
  name          = "bronze_source1"
  force_destroy = true
}

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

resource "azurerm_role_assignment" "ext_storage" {
  depends_on           = [azurerm_storage_container.ext_storage_container]
  scope                = azurerm_storage_account.ext_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.access_connector_id
}

resource "databricks_external_location" "landing-external-location" {
  depends_on      = [azurerm_role_assignment.ext_storage]
  name            = var.landing_external_location_name
  url             = var.landing_adls_path
  credential_name = var.storage_credential_name
  comment         = "Created by TF"
}
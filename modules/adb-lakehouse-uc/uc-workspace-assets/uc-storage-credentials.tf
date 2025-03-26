resource "databricks_storage_credential" "storage-credential" {
  name = var.storage_credential_name
  azure_managed_identity {
    access_connector_id = var.access_connector_id
  }
  comment = "Managed identity credential managed by TF"
  isolation_mode = "ISOLATION_MODE_ISOLATED"
}

resource "databricks_grants" "storage-credential-grants" {
  depends_on        = [databricks_storage_credential.storage-credential]
  storage_credential = databricks_storage_credential.storage-credential.id
  dynamic "grant" {
    for_each = toset(var.metastore_admins)
    content {
      principal  = grant.key
      privileges = ["CREATE EXTERNAL LOCATION", "CREATE EXTERNAL TABLE", "READ FILES", "WRITE_FILES"]
    }
  }
}



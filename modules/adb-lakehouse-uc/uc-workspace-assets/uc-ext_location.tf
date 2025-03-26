resource "databricks_external_location" "workspace-external-location" {
  depends_on        = [databricks_grants.storage-credential-grants]
  name            = var.external_location_name
  url             = var.adls_path
  credential_name = var.storage_credential_name
  comment         = "Created by TF"
  isolation_mode = "ISOLATION_MODE_ISOLATED"
}

resource "databricks_grants" "workspace-external-location-grants" {
  depends_on        = [databricks_external_location.workspace-external-location]
  external_location = var.external_location_name
  dynamic "grant" {
    for_each = toset(var.metastore_admins)
    content {
      principal  = grant.key
      privileges = ["BROWSE", "CREATE_EXTERNAL_TABLE", "CREATE_EXTERNAL_VOLUME", "CREATE_FOREIGN_SECURABLE", 
      "CREATE_MANAGED_STORAGE","READ_FILES", "WRITE_FILES", "MANAGE"]
    }
  }
}
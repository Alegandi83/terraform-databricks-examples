resource "databricks_external_location" "landing-external-location" {
  depends_on      = [azurerm_role_assignment.ext_storage_assignment]
  name            = var.landing_external_location_name
  url             = var.landing_adls_path
  credential_name = var.storage_credential_name
  comment         = "Created by TF"
}

resource "databricks_grants" "landing-external-location-grants" {
  depends_on        = [databricks_external_location.landing-external-location]
  external_location = var.landing_external_location_name
  dynamic "grant" {
    for_each = toset(var.metastore_admins)
    content {
      principal  = grant.key
      privileges = ["READ_FILES", "WRITE_FILES"]
    }
  }
}
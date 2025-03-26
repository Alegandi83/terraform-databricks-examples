resource "databricks_grants" "catalog_bronze-grants" {
  depends_on = [databricks_catalog.bronze-catalog]
  catalog    = "bronze_catalog"
  dynamic "grant" {
    for_each = toset(var.metastore_admins)
    content {
      principal = grant.key
      privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "EXECUTE", "CREATE_SCHEMA",
      "CREATE_FUNCTION", "CREATE_TABLE", "MODIFY"]
    }
  }
}
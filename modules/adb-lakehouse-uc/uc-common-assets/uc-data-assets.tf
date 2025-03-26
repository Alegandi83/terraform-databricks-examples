resource "databricks_catalog" "bronze-catalog" {
  metastore_id  = var.metastore_id
  name          = "bronze_catalog"
  comment       = "this catalog is for the bronze layer"
  force_destroy = true
}

resource "databricks_schema" "bronze_source1-schema" {
  depends_on    = [databricks_catalog.bronze-catalog]
  catalog_name  = databricks_catalog.bronze-catalog.name
  name          = "bronze_schema"
  force_destroy = true
}
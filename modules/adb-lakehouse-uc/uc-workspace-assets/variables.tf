
variable "external_location_name" {
  type        = string
  description = "the name of the workspace storage external location"
}

variable "adls_path" {
  type        = string
  description = "The ADLS path of the workspace storage external location"
}

variable "storage_credential_name" {
  type        = string
  description = "the name of the storage credential"
}

variable "metastore_admins" {
  type        = list(string)
  description = "list of principals: service principals or groups that have metastore admin privileges"
}

variable "access_connector_id" {
  type        = string
  description = "the id of the access connector"
}

variable "tags" {
  type        = map(string)
  description = "(Required) Map of tags to attach to resources"
}
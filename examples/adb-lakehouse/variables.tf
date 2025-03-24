variable "tenant_id" {
  type        = string
  description = "Azure Tenand ID to deploy the workspace into"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID to deploy the workspace into"
}

variable "account_id" {
  type        = string
  description = "Databricks Account ID"
}


variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "deploy_id" {
  type        = string
  description = "(Required) The global unique identifier for the owner of deployment: e.g. ag83"
}

variable "deploy_env" {
  type        = string
  description = "(Required) The environment for the deployment: e.g. tf"
}

variable "deploy_prj" {
  type        = string
  description = "(Required) The prject name for the deployment: e.g. test"
}

variable "deploy_ver" {
  type        = string
  description = "(Required) The version for the deployment: e.g. 001"
}

variable "spoke_vnet_address_space" {
  type        = string
  description = "(Required) The address space for the spoke Virtual Network"
}

variable "private_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space for private Databricks subnet"
}

variable "public_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space for public Databricks subnet"
}

variable "metastore_admins" {
  type        = list(string)
  description = "list of principals: service principals or groups that have metastore admin privileges"
}

variable "tags" {
  type        = map(string)
  description = "(Required) Map of tags to attach to resources"
  default     = {}
}


variable "create_resource_group" {
  type        = bool
  description = "(Optional) Creates resource group if set to true (default)"
  default     = true
}


variable "service_principals" {
  type = map(object({
    sp_id        = string
    display_name = optional(string)
    permissions  = list(string)
  }))
  default     = {}
  description = "list of service principals we want to create at Databricks account"
}








locals {
  metastore_name = "hub"
}
module "adb-lakehouse-uc-metastore" {
  source                     = "../../modules/adb-uc-metastore"
  metastore_storage_name     = "dls${var.deploy_id}${var.deploy_env}${local.metastore_name}${var.deploy_ver}"
  metastore_name             = "mts-${var.deploy_id}-${var.deploy_env}-${local.metastore_name}-${var.deploy_ver}"
  access_connector_name      = "dac-${var.deploy_id}-${var.deploy_env}-${local.metastore_name}-${var.deploy_ver}"
  shared_resource_group_name = "rg-${var.deploy_id}-${var.deploy_env}-${local.metastore_name}-${var.deploy_ver}"
  location                   = var.location
  tags                       = merge(var.tags, { "Domain" = "${local.metastore_name}" })
  providers = {
    databricks = databricks.account
  }
}

module "adb-lakehouse-uc-account-principals" {
  source             = "../../modules/adb-lakehouse-uc/account-principals"
  service_principals = var.service_principals
  providers = {
    databricks = databricks.account
  }
}

locals {
  producer_name = "producer"
}
module "adb-lakehouse-producer" {
  # With UC by default we need to explicitly create a UC metastore, otherwise it will be created automatically
  depends_on                      = [module.adb-lakehouse-uc-metastore]
  source                          = "../../modules/adb-lakehouse"
  deploy_id                       = var.deploy_id
  deploy_env                      = var.deploy_env
  deploy_prj                      = var.deploy_prj
  deploy_ver                      = var.deploy_ver
  component_name                  = "${local.producer_name}"
  location                        = var.location
  spoke_vnet_address_space        = var.spoke_vnet_address_space
  spoke_resource_group_name       = "rg-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-${var.deploy_ver}"
  create_resource_group           = var.create_resource_group
  managed_resource_group_name     = "rg-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-${var.deploy_ver}-mngd"
  databricks_workspace_name       = "dbw-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-${var.deploy_ver}"
  data_factory_name               = "" #"adf-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-${var.deploy_ver}"
  key_vault_name                  = "" #"akv-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-${var.deploy_ver}"
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  storage_account_name            = "dls${var.deploy_id}${var.deploy_env}${local.producer_name}${var.deploy_ver}"
  tags                            = merge(var.tags, { "Domain" = "${local.producer_name}" })
}


module "adb-lakehouse-uc-idf-assignment" {
  depends_on         = [module.adb-lakehouse-uc-account-principals]
  source             = "../../modules/uc-idf-assignment"
  workspace_id       = module.adb-lakehouse-producer.workspace_id
  metastore_id       = module.adb-lakehouse-uc-metastore.metastore_id
  service_principals = var.service_principals
  account_groups = {
    "group1" = {
      group_name  = "grp-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-admins-${var.deploy_ver}"
      permissions = ["ADMIN"]
    },
    "group2" = {
      group_name  = "grp-${var.deploy_id}-${var.deploy_env}-${local.producer_name}-users-${var.deploy_ver}"
      permissions = ["USER"]
    }
  }
  providers = {
    databricks = databricks.account
  }
}


locals {
  consumer_name = "consumer"
}
module "adb-lakehouse-consumer" {
  # With UC by default we need to explicitly create a UC metastore, otherwise it will be created automatically
  depends_on                      = [module.adb-lakehouse-uc-metastore]
  source                          = "../../modules/adb-lakehouse"
  deploy_id                       = var.deploy_id
  deploy_env                      = var.deploy_env
  deploy_prj                      = var.deploy_prj
  deploy_ver                      = var.deploy_ver
  component_name                  = "${local.consumer_name}"
  location                        = var.location
  spoke_vnet_address_space        = var.spoke_vnet_address_space
  spoke_resource_group_name       = "rg-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-${var.deploy_ver}"
  create_resource_group           = var.create_resource_group
  managed_resource_group_name     = "rg-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-${var.deploy_ver}-mngd"
  databricks_workspace_name       = "dbw-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-${var.deploy_ver}"
  data_factory_name               = "" #"adf-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-${var.deploy_ver}"
  key_vault_name                  = "" #"akv-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-${var.deploy_ver}"
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  storage_account_name            = "dls${var.deploy_id}${var.deploy_env}${local.consumer_name}${var.deploy_ver}"
  tags                            = merge(var.tags, { "Domain" = "${local.consumer_name}" })
}



module "adb-lakehouse-other-uc-idf-assignment" {
  depends_on         = [module.adb-lakehouse-uc-account-principals]
  source             = "../../modules/uc-idf-assignment"
  workspace_id       = module.adb-lakehouse-consumer.workspace_id
  metastore_id       = module.adb-lakehouse-uc-metastore.metastore_id
  service_principals = var.service_principals
  account_groups = {
    "group1" = {
      group_name  = "grp-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-admins-${var.deploy_ver}"
      permissions = ["ADMIN"]
    },
    "group2" = {
      group_name  = "grp-${var.deploy_id}-${var.deploy_env}-${local.consumer_name}-users-${var.deploy_ver}"
      permissions = ["USER"]
    }
  }
  providers = {
    databricks = databricks.account
  }
}




locals {
  landing_name = "land"
}
module "adb-lakehouse-common-assets" {
  depends_on                     = [module.adb-lakehouse-uc-metastore]
  source                         = "../../modules/adb-lakehouse-uc/uc-common-assets"
  location                       = var.location
  storage_credential_name        = "dac-${var.deploy_id}-${var.deploy_env}-${local.metastore_name}-${var.deploy_ver}"
  metastore_id                   = module.adb-lakehouse-uc-metastore.metastore_id
  access_connector_id            = module.adb-lakehouse-uc-metastore.access_connector_principal_id
  landing_external_location_name = "dls${var.deploy_id}${var.deploy_env}${local.landing_name}${var.deploy_ver}"
  landing_adls_path              = format("abfss://%s@%s.dfs.core.windows.net/", "con", "dls${var.deploy_id}${var.deploy_env}${local.landing_name}${var.deploy_ver}")
  landing_adls_rg                = module.adb-lakehouse-uc-metastore.shared_resource_group_name
  metastore_admins               = var.metastore_admins
  tags                           = merge(var.tags, { "Domain" = "${local.landing_name}" })
  providers = {
    databricks = databricks.producer-workspace
  }
}

locals {
  producer_assets_name = "producer-assets"
}
module "adb-lakehouse-producer-workspace-assets" {
  depends_on                     = [module.adb-lakehouse-metastore-landing]
  source                         = "../../modules/adb-lakehouse-uc/uc-workspace-assets"
  access_connector_id            = module.adb-lakehouse-producer.access_connector_principal_id
  storage_credential_name        = module.adb-lakehouse-producer.access_connector_name
  external_location_name         = module.adb-lakehouse-producer.storage_account_name
  adls_path                      = format("abfss://%s@%s.dfs.core.windows.net/", "con", module.adb-lakehouse-producer.storage_account_name)
  metastore_admins               = var.metastore_admins
  tags                           = merge(var.tags, { "Domain" = "${local.producer_assets_name}" })
  providers = {
    databricks = databricks.producer-workspace
  }
}

locals {
  consumer_assets_name = "consumer-assets"
}
module "adb-lakehouse-consumer-workspace-assets" {
  depends_on                     = [module.adb-lakehouse-producer-workspace-assets]
  source                         = "../../modules/adb-lakehouse-uc/uc-metastore-assets"
  access_connector_id            = module.adb-lakehouse-consumer.access_connector_principal_id
  storage_credential_name        = module.adb-lakehouse-consumer.access_connector_name
  external_location_name         = module.adb-lakehouse-consumer.storage_account_name
  adls_path                      = format("abfss://%s@%s.dfs.core.windows.net/", "con", module.adb-lakehouse-consumer.storage_account_name)
  metastore_admins               = var.metastore_admins
  tags                           = merge(var.tags, { "Domain" = "${local.producer_assets_name}" })
  providers = {
    databricks = databricks.consumer-workspace
  }
}

locals {
  assets_name = "data-assets"
}
#module "adb-lakehouse-data-assets" {
#  depends_on                     = [module.adb-lakehouse-consumer-workspace-assets]
#  source                         = "../../modules/adb-lakehouse-uc/uc-data-assets"
#  location                       = var.location
#  storage_credential_name        = "dac-${var.deploy_id}-${var.deploy_env}-${local.metastore_name}-${var.deploy_ver}"
#  metastore_id                   = module.adb-lakehouse-uc-metastore.metastore_id
#  metastore_admins               = var.metastore_admins
#  tags                           = merge(var.tags, { "Domain" = "${local.assets_name}" })
#  providers = {
#    databricks = databricks.producer-workspace
#  }
#}
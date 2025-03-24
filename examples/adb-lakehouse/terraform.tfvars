tenant_id                       = "bf465dc7-3bc8-4944-b018-092572b5c20d"  
subscription_id                 = "edd4cc45-85c7-4aec-8bf5-648062d519bf"
account_id                      = "ccb842e7-2376-4152-b0b0-29fa952379b8"

location                        = "westeurope"
deploy_id                       = "ag83"
deploy_env                      = "tf"      #environment
deploy_prj                      = "test"    #project name
deploy_ver                      = "001"     #version


spoke_vnet_address_space        = "10.178.0.0/16"
private_subnet_address_prefixes = ["10.178.0.0/20"]
public_subnet_address_prefixes  = ["10.178.16.0/20"]

metastore_admins                = ["alessandro.gandini@databricks.com"]

tags = {
  Owner = "alessandro.gandini@databricks.com"
}
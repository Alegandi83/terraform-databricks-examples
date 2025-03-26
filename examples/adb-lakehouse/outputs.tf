output "producer_azure_resource_group_id" {
  description = "ID of the created Azure resource group"
  value       = module.adb-lakehouse-producer.azure_resource_group_id
}

output "producer_workspace_id" {
  description = "The Databricks workspace ID"
  value       = module.adb-lakehouse-producer.workspace_id
}

output "producer_workspace_url" {
  description = "The Databricks workspace URL"
  value       = module.adb-lakehouse-producer.workspace_url
}

output "consumer_azure_resource_group_id" {
  description = "ID of the created Azure resource group"
  value       = module.adb-lakehouse-consumer.azure_resource_group_id
}

output "consumer_workspace_id" {
  description = "The Databricks workspace ID"
  value       = module.adb-lakehouse-consumer.workspace_id
}

output "consumer_workspace_url" {
  description = "The Databricks workspace URL"
  value       = module.adb-lakehouse-consumer.workspace_url
}
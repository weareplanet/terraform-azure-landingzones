variable "app_config" {
  default = {}
}
variable "app_config_entries" {
  description = "Map of objects describing kv entries to an app config."
  default     = {}
}
variable "azurerm_redis_caches" {
  default = {}
}
variable "cosmos_dbs" {
  default = {}
}
variable "cosmosdb_sql_databases" {
  default = {}
}
variable "cosmosdb_role_definitions" {
  default = {}
}
variable "cosmosdb_role_mapping" {
  default = {}
}
variable "database" {
  description = "Database configuration objects"
  default     = {}
}
variable "databricks_workspaces" {
  default = {}
}
variable "machine_learning_workspaces" {
  default = {}
}
variable "mariadb_databases" {
  default = {}
}
variable "mariadb_servers" {
  default = {}
}
variable "mssql_databases" {
  default = {}
}
variable "mssql_elastic_pools" {
  default = {}
}
variable "mssql_failover_groups" {
  default = {}
}
variable "mssql_managed_databases" {
  default = {}
}
variable "mssql_managed_databases_backup_ltr" {
  default = {}
}
variable "mssql_managed_databases_restore" {
  default = {}
}
variable "mssql_managed_instances" {
  default = {}
}
variable "mssql_managed_instances_secondary" {
  default = {}
}
variable "mssql_mi_administrators" {
  default = {}
}
variable "mssql_mi_failover_groups" {
  default = {}
}
variable "mssql_mi_secondary_tdes" {
  default = {}
}
variable "mssql_mi_tdes" {
  default = {}
}
variable "mssql_servers" {
  default = {}
}
variable "mysql_databases" {
  default = {}
}
variable "mysql_servers" {
  default = {}
}
variable "mysql_flexible_server" {
  default = {}
}
variable "postgresql_flexible_servers" {
  default = {}
}
variable "postgresql_servers" {
  default = {}
}
variable "synapse_workspaces" {
  default = {}
}

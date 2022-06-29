# Map of the remote data state for lower level
variable "lower_storage_account_name" {}
variable "lower_container_name" {}
variable "lower_resource_group_name" {}

variable "tfstate_storage_account_name" {}
variable "tfstate_container_name" {}
variable "tfstate_key" {}
variable "tfstate_resource_group_name" {}

variable "tenant_id" {}
variable "landingzone" {}
variable "tfstate_subscription_id" {}
variable "global_settings" {
  default = {}
}
variable "rover_version" {
  default = null
}
variable "tags" {
  default = null
}

variable "managed_identities" {
  default = {}
}
variable "keyvaults" {
  default = {}
}

variable "github" {}
variable "gh_repo_secrets" {
  default = {}
}

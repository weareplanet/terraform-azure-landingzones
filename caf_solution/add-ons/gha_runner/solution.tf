module "caf" {
  #source  = "aztfmod/caf/azurerm"
  #version = "~>5.4.2"

  source = "git::https://github.com/weareplanet/terraform-azure-caf.git?ref=main"

  providers = {
    azurerm.vhub = azurerm.vhub
  }

  azuread                     = local.azuread
  current_landingzone_key     = var.landingzone.key
  database                    = local.database
  tenant_id                   = var.tenant_id
  tfstates                    = local.tfstates
  tags                        = local.tags
  security                    = local.security
  global_settings             = local.global_settings
  diagnostics                 = local.diagnostics
  diagnostic_storage_accounts = var.diagnostic_storage_accounts
  logged_user_objectId        = var.logged_user_objectId
  logged_aad_app_objectId     = var.logged_aad_app_objectId
  resource_groups             = var.resource_groups
  storage_accounts            = var.storage_accounts
  keyvaults                   = var.keyvaults
  keyvault_access_policies    = var.keyvault_access_policies
  managed_identities          = var.managed_identities
  role_mapping                = var.role_mapping
  custom_role_definitions     = var.custom_role_definitions
  compute = {
    virtual_machines = var.virtual_machines
  }
  storage = {
    storage_account_blobs = var.storage_account_blobs
  }

  # Pass the remote objects you need to connect to.
  remote_objects = {
    keyvaults          = local.remote.keyvaults
    managed_identities = local.remote.managed_identities
    azuread_groups     = local.remote.azuread_groups
    vnets              = local.remote.vnets
    app_config         = local.remote.app_config
    container_registry = local.remote.azure_container_registries
  }
}

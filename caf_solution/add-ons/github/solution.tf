module "caf" {
  source = "git::https://github.com/weareplanet/terraform-azure-caf.git?ref=main"

  providers = {
    azurerm.vhub = azurerm.vhub
  }

  logged_user_objectId                  = var.logged_user_objectId
  logged_aad_app_objectId               = var.logged_aad_app_objectId
  managed_identities                    = var.managed_identities
  keyvaults                             = var.keyvaults

  remote_objects = {
    keyvaults          = local.remote.keyvaults
    managed_identities = local.remote.managed_identities
    app_config         = local.remote.app_config
  }
}

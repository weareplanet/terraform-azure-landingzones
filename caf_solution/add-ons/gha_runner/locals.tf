locals {
  azuread = merge(
    var.azuread,
    {
      azuread_apps   = var.azuread_apps
      azuread_groups = var.azuread_groups
    }
  )

  database = merge(
    var.database,
    {
      app_config_entries = var.app_config_entries
    }
  )

  security = merge(
    var.security,
    {
      dynamic_keyvault_secret = var.dynamic_keyvault_secrets
    }
  )
}

data "azurerm_key_vault_secret" "secret" {
  for_each = { for key, value in try(local.keyvault_secrets, {}) : key => value }

  name         = each.value.secret_name
  key_vault_id = try(each.value.lz_key, null) == null ? local.combined.keyvaults[var.landingzone.key][each.value.keyvault_key].id : local.combined.keyvaults[each.value.lz_key][each.value.keyvault_key].id
}

resource "github_actions_secret" "dynamic_secret" {
  for_each = {
    for key, value in try(local.dynamic_secrets, {}) : key => value
    if try(value.environment, null) == null
  }

  repository      = each.value.repo_name
  secret_name     = each.value.secret_key
  plaintext_value = each.value.secret_value
}

resource "github_actions_environment_secret" "dynamic_env_secret" {
  for_each = {
    for key, value in try(local.dynamic_secrets, {}) : key => value
    if try(value.environment, null) != null
  }
  depends_on = [github_repository_environment.env]

  repository      = each.value.repo_name
  environment     = each.value.environment
  secret_name     = each.value.secret_key
  plaintext_value = each.value.secret_value
}

resource "github_actions_secret" "keyvault_secret" {
  for_each = {
    for key, value in try(local.keyvault_secrets, {}) : key => value
    if try(value.environment, null) == null
  }

  repository      = each.value.repo_name
  secret_name     = each.value.secret_key
  plaintext_value = data.azurerm_key_vault_secret.secret[each.key].value
}

resource "github_actions_environment_secret" "keyvault_env_secret" {
  for_each = {
    for key, value in try(local.keyvault_secrets, {}) : key => value
    if try(value.environment, null) != null
  }
  depends_on = [github_repository_environment.env]

  repository      = each.value.repo_name
  environment     = each.value.environment
  secret_name     = each.value.secret_key
  plaintext_value = data.azurerm_key_vault_secret.secret[each.key].value
}

locals {
  dynamic_secrets = {
    for secret in flatten([
      for repo_name, repo_config in try(var.gh_repo_secrets, {}) : [
        for secret in try(repo_config.dynamic, []) : [
          for secret_key, secret_config in secret : [
            for resource_type_key, resource in secret_config : [
              for object_id_key, object_attributes in resource : {
                value = {
                  secret_key   = secret_key
                  secret_value = try(local.combined[resource_type_key][object_attributes.lz_key][object_id_key][object_attributes.attribute_key], local.combined[resource_type_key][var.landingzone.landingzone_key][object_id_key][object_attributes.attribute_key])
                  repo_name    = repo_name
                  environment  = try(object_attributes.environment, null)
                }
              }
            ]
          ]
        ]
      ]
      ]
    ) : format("%s-%s", secret.value.secret_key, try(secret.value.environment, "")) => secret.value
  }

  keyvault_secrets = {
    for secret in flatten([
      for repo_name, repo_config in try(var.gh_repo_secrets, {}) : [
        for secret in try(repo_config.keyvault, []) : [
          for secret_key, secret_config in secret : {
            value = {
              secret_key   = secret_key
              secret_name  = secret_config.name
              keyvault_key = secret_config.key
              lz_key       = secret_config.lz_key
              environment  = try(secret_config.environment, null)
              repo_name    = repo_name
            }
          }
        ]
      ]
    ]) : format("%s-%s", secret.value.secret_key, try(secret.value.environment, "")) => secret.value
  }
}

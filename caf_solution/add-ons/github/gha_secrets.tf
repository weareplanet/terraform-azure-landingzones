resource "github_actions_secret" "secret" {
  for_each = try(merge(local.static_secrets, local.dynamic_secrets), {})

  repository      = each.value.repo_name
  secret_name     = each.key
  plaintext_value = each.value.secret_value
}

locals {
  static_secrets = {
    for setting in flatten(
      [
        for repo_name, repo_config in try(var.gh_repo_secrets, []) : [
          for secret_key, secret_value in try(repo_config.static, []) : {
            key = secret_key
            value = {
              secret_value = secret_value
              repo_name    = repo_name
            }
          }
        ]
      ]
    ) : setting.key => setting.value
  }

  dynamic_secrets = {
    for setting in flatten(
      [
        for repo_name, repo_config in try(var.gh_repo_secrets, []) : [
          for secret_key, secret_config in try(repo_config.dynamic, []) : [
            for resource_type_key, resource in secret_config : [
              for object_id_key, object_attributes in resource : {
                key = secret_key
                value = {
                  secret_value = try(local.combined[resource_type_key][object_attributes.lz_key][object_id_key][object_attributes.attribute_key], local.combined[resource_type_key][var.landingzone.landingzone_key][object_id_key][object_attributes.attribute_key])
                  repo_name    = repo_name
                }
              }
            ]
          ]
        ]
      ]
    ) : setting.key => setting.value
  }
}

module "dynamic_keyvault_secrets" {
  source = "git::https://github.com/weareplanet/terraform-azure-caf.git//modules/security/dynamic_keyvault_secrets?ref=main"
  # source = "../../terraform-azure-caf//modules/security/dynamic_keyvault_secrets"

  for_each = {
    for keyvault_key, secrets in try(var.dynamic_keyvault_secrets, {}) : keyvault_key => {
      for key, value in secrets : key => value
      if try(value.value, null) == null
    }
  }

  settings = each.value
  keyvault = module.solution.keyvaults[each.key]
  objects  = module.solution
}

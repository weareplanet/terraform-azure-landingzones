terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13"
}

provider "github" {
  token = data.azurerm_key_vault_secret.github_pat.value
  owner = var.github.gh_org
}

provider "azurerm" {
  partner_id = "ca4078f8-9bc4-471b-ab5b-3af6b86a42c8"
  # partner identifier for CAF Terraform landing zones.
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias                      = "vhub"
  skip_provider_registration = true
  features {}
}

data "azurerm_key_vault_secret" "github_pat" {
  name         = var.github.pat.secret_name
  key_vault_id = try(var.github.pat.lz_key, null) == null ? local.combined.keyvaults[var.landingzone.key][var.github.pat.keyvault_key].id : local.combined.keyvaults[var.github.pat.lz_key][var.github.pat.keyvault_key].id
}

data "azurerm_client_config" "current" {}

locals {
  # Update the tfstates map
  tfstates = merge(
    tomap(
      {
        (var.landingzone.key) = local.backend[var.landingzone.backend_type]
      }
    )
    ,
    data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.tfstates
  )

  backend = {
    azurerm = {
      storage_account_name = var.tfstate_storage_account_name
      container_name       = var.tfstate_container_name
      resource_group_name  = var.tfstate_resource_group_name
      key                  = var.tfstate_key
      level                = var.landingzone.level
      tenant_id            = var.tenant_id
      subscription_id      = data.azurerm_client_config.current.subscription_id
    }
  }
}

# Map of the remote data state for lower level
variable "lower_storage_account_name" {
  default = null
}
variable "lower_container_name" {
  default = null
}
variable "lower_resource_group_name" {
  default = null
}
variable "custom_variables" {
  description = "Global custom variables to allow sharing variables between tfstates."
  default     = {}
}
variable "tfstate_subscription_id" {
  description = "This value is propulated by the rover. subscription id hosting the remote tfstates"
  default     = null
}
variable "tfstate_storage_account_name" {
  default = null
}
variable "tfstate_container_name" {
  default = null
}
variable "tfstate_key" {
  default = null
}
variable "tfstate_resource_group_name" {
  default = null
}
variable "tfstate_organization" {
  default = null
}
variable "tfstate_hostname" {
  default = null
}
variable "workspace" {
  default = null
}
variable "sas_token" {
  description = "SAS Token to access the remote state in another Azure AD tenant."
  default     = null
}

variable "landingzone" {
  default = {
    backend_type        = "azurerm"
    global_settings_key = "launchpad"
    level               = "level1"
    key                 = "caf_examples"
    tfstates = {
      launchpad = {
        level   = "lower"
        tfstate = "caf_launchpad.tfstate"
      }
    }
  }
}

variable "global_settings" {
  default = {}
}

variable "rover_version" {
  default = "caf_standalone"
}

variable "client_config" {
  default = {}
}

variable "tenant_id" {
  description = "Azure AD Tenant ID for the current deployment."
  default     = null
}

variable "current_landingzone_key" {
  description = "Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment."
  default     = "local"
  type        = string
}

variable "tfstates" {
  description = "Terraform states configuration object. Used in the context of landing zone deployment."
  default     = {}
}

variable "enable" {
  description = "Map of services defined in the configuration file you want to disable during a deployment."
  default = {
    # bastion_hosts    = true
    # virtual_machines = true
  }
}

variable "environment" {
  description = "Name of the CAF environment."
  type        = string
  default     = "sandpit"
}

variable "logged_user_objectId" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  default     = null
}
variable "logged_aad_app_objectId" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  default     = null
}

variable "use_msi" {
  description = "Deployment using an MSI for authentication."
  default     = false
  type        = bool
}

variable "tags" {
  description = "Tags to be used for this resource deployment."
  type        = map(any)
  default     = {}
}

variable "resource_groups" {
  description = "Resource groups configuration objects"
  default     = {}
}

variable "subscriptions" {
  default = {}
}

variable "subscription_billing_role_assignments" {
  default = {}
}

variable "billing" {
  description = "Billing information"
  default     = {}
}

variable "remote_objects" {
  description = "Remote objects is used to allow the landing zone to retrieve remote tfstate objects and pass them to the caf module"
  default     = {}
}

variable "data_sources" {
  description = "Data gathering for resources not managed by CAF Module"
  default = {}
}

## Diagnostics settings
variable "diagnostics_definition" {
  default     = null
  description = "Shared diadgnostics settings that can be used by the services to enable diagnostics"
}

variable "diagnostics_destinations" {
  default = null
}

variable "log_analytics" {
  default = {}
}

variable "diagnostics" {
  default = {}
}

variable "event_hub_namespaces" {
  default = {}
}

variable "subnet_id" {
  default = {}
}

variable "user_type" {
  description = "The rover set this value to user or serviceprincipal. It is used to handle Azure AD api consents."
  default     = {}
}


variable "managed_identities" {
  description = "Managed Identity configuration objects"
  default     = {}
}

variable "keyvaults" {
  description = "Key Vault configuration objects"
  default     = {}
}

variable "keyvault_access_policies" {
  default = {}
}

variable "keyvault_access_policies_azuread_apps" {
  default = {}
}

variable "custom_role_definitions" {
  description = "Custom role definitions configuration objects"
  default     = {}
}
variable "role_mapping" {
  default = {
    built_in_role_mapping = {}
    custom_role_mapping   = {}
  }
}

variable "dynamic_keyvault_secrets" {
  default = {}
}


variable "diagnostic_storage_accounts" {
  default = {}
}


variable "event_hubs" {
  default = {}
}

variable "event_hub_auth_rules" {
  default = {}
}

variable "event_hub_namespace_auth_rules" {
  default = {}
}

variable "event_hub_consumer_groups" {
  default = {}
}

variable "diagnostic_event_hub_namespaces" {
  default = {}
}
variable "diagnostic_log_analytics" {
  default = {}
}
variable "var_folder_path" {
  default = null
}
variable "propagate_launchpad_identities" {
  default = false
}
variable "random_strings" {
  default = {}
}
variable "search_services" {
  default     = {}
}
variable "cdn_frontdoor_profiles" {
  description = "Configuring Front Door Profiles."
  default     = {}
  type        = any
}

variable "cdn" {
  description = <<DESCRIPTION
  Configuration object - Azure CDN resources"

  This variable is used to define the settings for Azure CDN resources, such as profiles, endpoints, origin groups, origins, rule sets, and rules.
  These are the settings that can be configured:
  - profiles: (Optional) A map of CDN profiles, where each key is a unique identifier for the profile and the value is an object containing the profile settings.
    - name: (Required) The name of the CDN profile.
    - location: (Required) The Azure region where the CDN profile will be created.
    - resource_group_key: (Optional) The key of the resource group in which the CDN profile will be created. If not provided, it defaults to the current landing zone's resource group.
    - sku_name: (Required) The SKU name for the CDN profile, such as "Standard_AzureFrontDoor" or "Premium_AzureFrontDoor".
  - base_tags: (Optional) A map of tags to be applied to the CDN resources. If not provided, it defaults to the global settings' inherited tags.
  - location: (Optional) The Azure region where the CDN resources will be created. If not provided, it defaults to the profile's location.
  - endpoints: (Optional) A map of CDN endpoints, where each key is a unique identifier for the endpoint and the value is an object containing the endpoint settings.
  - origin_groups: (Optional) A map of CDN origin groups, where each key is a unique identifier for the origin group and the value is an object containing the origin group settings.
  - origins: (Optional) A map of CDN origins, where each key is a unique identifier for the origin and the value is an object containing the origin settings.
  - rule_sets: (Optional) A map of CDN rule sets, where each key is a unique identifier for the rule set and the value is an object containing the rule set settings.
  - rules: (Optional) A map of CDN rules, where each key is a unique identifier for the rule and the value is an object containing the rule settings.
  - custom_domains: (Optional) A map of custom domains, where each key is a unique identifier for the custom domain and the value is an object containing the custom domain settings.


  For example, you can define a CDN profile with the following structure:
  cdn = {
    profiles = {
      profile1 = {
        name                = "my-cdn-profile"
        location            = "westeurope"
        resource_group_key  = "my_resource_group"
        sku_name            = "Standard_AzureFrontDoor"
        custom_domains      = {}
        endpoints           = {}
        origin_groups       = {}
        origins             = {}
        rule_sets           = {}
        rules               = {}
      }
    }
  }
  This allows you to create and manage Azure CDN resources in a structured way, making it easier to deploy and maintain your CDN configurations.
  DESCRIPTION
  type        = any
  default     = {}
}

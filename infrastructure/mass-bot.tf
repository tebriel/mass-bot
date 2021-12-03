resource "azurerm_resource_group" "mass-bot" {
  name     = "mass-bot"
  location = "East US 2"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "mass-bot" {
  name                        = "mass-bot"
  location                    = azurerm_resource_group.mass-bot.location
  resource_group_name         = azurerm_resource_group.mass-bot.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover",
      "list"
    ]

    storage_permissions = [
      "get",
    ]
  }
}

resource "azurerm_app_service_plan" "mass-bot" {
  name                = "mass-bot"
  location            = azurerm_resource_group.mass-bot.location
  resource_group_name = azurerm_resource_group.mass-bot.name

  kind     = "Linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "mass-bot" {
  name                = "mass-bot"
  location            = azurerm_resource_group.mass-bot.location
  resource_group_name = azurerm_resource_group.mass-bot.name
  app_service_plan_id = azurerm_app_service_plan.mass-bot.id

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${azurerm_container_registry.acr.login_server}"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "BOT_GATEWAY_TOKEN"                   = ""
  }

  site_config {
    acr_use_managed_identity_credentials = true

    always_on        = false
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/mass-bot/mass-bot:26e8134ff013d46b65bb825d42235dafacfefa10"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [site_config[0].linux_fx_version, app_settings["BOT_GATEWAY_TOKEN"]]
  }

}

output "tfoutput" {
  value = azurerm_container_registry.acr.login_server
}
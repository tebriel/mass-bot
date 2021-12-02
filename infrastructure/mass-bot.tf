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
  name = "mass-bot"
  location = azurerm_resource_group.mass-bot.location
  resource_group_name = azurerm_resource_group.mass-bot.name

  kind = "Linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "mass-bot" {
  name = "mass-bot"
  location = azurerm_resource_group.mass-bot.location
  resource_group_name = azurerm_resource_group.mass-bot.name
  app_service_plan_id = azurerm_app_service_plan.mass-bot.id

  site_config {
    always_on = false
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/mass-bot:0b53e754dc29aee5f8be236e9311432145b8aeb2"
  }
}
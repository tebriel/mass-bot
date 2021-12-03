resource "azurerm_resource_group" "mass-bot" {
  name     = "mass-bot"
  location = "East US 2"
}

resource "azurerm_container_group" "mass-bot" {
  name                = "mass-bot"
  resource_group_name = azurerm_resource_group.mass-bot.name
  location            = azurerm_resource_group.mass-bot.location
  os_type             = "Linux"
  restart_policy      = "Always"
  dns_name_label      = "mass-bot"

  tags = {}

  container {
    name   = "mass-bot"
    image  = "${data.azurerm_container_registry.acr.login_server}/mass-bot/mass-bot:latest"
    cpu    = "1"
    memory = "1.5"
    environment_variables = {

    }
    secure_environment_variables = {
      BOT_GATEWAY_TOKEN = var.BOT_GATEWAY_TOKEN
    }

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  timeouts {}

  lifecycle {
    ignore_changes = [image_registry_credential, container]
  }
}
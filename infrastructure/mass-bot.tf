resource "azurerm_resource_group" "mass-bot" {
  name     = "mass-bot"
  location = "East US 2"
}

resource "azurerm_container_group" "mass-bot" {
  name                = "mass-bot"
  resource_group_name = azurerm_resource_group.mass-bot.name
  location            = azurerm_resource_group.mass-bot.location
  os_type             = "Linux"
  restart_policy      = "OnFailure"

  tags = {}

  container {
    name   = "mass-bot"
    image  = "${azurerm_container_registry.acr.login_server}/mass-bot/mass-bot:latest"
    cpu    = "1"
    memory = "1.5"
    environment_variables = {

    }
    secure_environment_variables = {
      BOT_GATEWAY_TOKEN = var.BOT_GATEWAY_TOKEN
    }

    ports {
      port     = 9090
      protocol = "UDP"
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  timeouts {}

  lifecycle {
    ignore_changes = [container[0].image, container[0].secure_environment_variables]
  }
}
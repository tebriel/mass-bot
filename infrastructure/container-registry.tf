data "azurerm_resource_group" "froudx-in" {
  name = "frodux.in"
}

resource "azurerm_user_assigned_identity" "mass-bot" {
  resource_group_name = azurerm_resource_group.mass-bot.name
  location            = azurerm_resource_group.mass-bot.location

  name = "mass-bot"
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "mass-bot-pull" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.mass-bot.principal_id
}

resource "azurerm_container_registry" "acr" {
  name                = "FroduxContainerRegistry"
  resource_group_name = data.azurerm_resource_group.froudx-in.name
  location            = data.azurerm_resource_group.froudx-in.location
  sku                 = "Premium"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.mass-bot.id
    ]
  }
}
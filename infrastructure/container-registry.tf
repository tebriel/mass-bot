data "azurerm_resource_group" "froudx-in" {
    name = "frodux.in"
}

resource "azurerm_container_registry" "acr" {
    name = "FroduxContainerRegistry"
    resource_group_name = data.azurerm_resource_group.froudx-in.name
    location = data.azurerm_resource_group.froudx-in.location
    sku = "Premium"
}
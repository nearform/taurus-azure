

resource "azurerm_container_registry" "acr" {
  name                     = "${module.labels.id}-acr"
  resource_group_name      = azurerm_resource_group.prod.name
  location                 = azurerm_resource_group.prod.location
  sku                      = "Standard"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}
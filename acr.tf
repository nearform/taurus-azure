resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = azurerm_resource_group.k8s.name
  location                 = var.location
  sku                      = "Standard"
  admin_enabled            = false
}
resource "azurerm_resource_group" "prod" {
  name     = "${module.labels.id}-rg"
  location = var.location
  }
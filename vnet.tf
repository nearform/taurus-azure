resource "azurerm_virtual_network" "default" {
  name = "${module.labels.id}-vnet"
  resource_group_name = "${module.labels.id}-rg"

  address_space = [
    "10.3.0.0/16"]
  location = var.location
  }

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.prod.name
  address_prefixes     = ["10.3.1.0/24"]
}
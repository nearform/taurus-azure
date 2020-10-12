resource "azurerm_virtual_network" "default" {
  name = "${module.labels.id}-vnet"
  resource_group_name = "${module.labels.id}-rg"

  address_space = [
    "10.3.0.0/16"]
  location = var.location
    subnet {
    name           = "subnet1"
    address_prefix = "10.3.1.0/24"
  }
}
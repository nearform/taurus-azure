resource "azurerm_virtual_network" "k8s" {
  name = "${module.labels.id}-vnet-k8s"
  resource_group_name = "${module.labels.id}-k8s"

  address_space = [
    "10.4.0.0/16"]
  location = var.location
  }

resource "azurerm_subnet" "k8s-internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.k8s.name
  resource_group_name  = azurerm_resource_group.k8s.name
  address_prefixes     = ["10.4.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}
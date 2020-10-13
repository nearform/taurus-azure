resource "azurerm_resource_group" "store" {
  name     = "${module.labels.id}-rg"
  location = var.location
  }
resource "azurerm_resource_group" "k8s" {
    name     = "${module.labels.id}-k8s"
    location = var.location
}
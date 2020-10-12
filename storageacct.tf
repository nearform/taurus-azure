resource "azurerm_storage_account" "default" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.prod.name
  location                 = azurerm_resource_group.prod.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_account" "store" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.store.name
  location                 = azurerm_resource_group.store.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "random_id" "random" {
    byte_length = 8
}

resource "azurerm_storage_account" "default" {
  name                     = "storageacct-${random_id.random.dec}"
  resource_group_name      = azurerm_resource_group.prod.name
  location                 = azurerm_resource_group.prod.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
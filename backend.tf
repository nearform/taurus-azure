terraform {
  backend "azurerm" {
   resource_group_name  = azurerm_resource_group.store.name
   storage_account_name = azurerm_storage_account.store.name
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
 }
}
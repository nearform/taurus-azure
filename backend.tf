terraform {
  backend "azurerm" {
    resource_group_name  = "${module.labels.id}-rg"
    storage_account_name = "${module.labels.id}-sg"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
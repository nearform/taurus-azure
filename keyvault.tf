data "azurerm_client_config" "current" {
}

resource "random_id" "server" {
  keepers = {
    ami_id = 1
  }

  byte_length = 8
}
resource "random_password" "password" {
  count = 2
  length = 16
  special = true
  override_special = "_%@"
}

resource "azurerm_key_vault" "kv" {
  name                = format("%s-%s", azurerm_resource_group.store.name, "kv")
  location            = var.location
  resource_group_name = azurerm_resource_group.store.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "list"
    ]
  }
  network_acls {
    default_action = "Allow"
    bypass = "AzureServices"
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_key_vault_secret" "db_admin" {
  name         = "psqladminun"
  value        = random_password.password[0].result
  key_vault_id = azurerm_key_vault.kv.id
  tags = {
    environment = var.environment
  }
}
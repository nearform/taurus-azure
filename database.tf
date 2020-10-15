
resource "azurerm_postgresql_server" "dbServer" {
  name                = "${var.db_name_prefix}-${random_string.random.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.store.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "psqladminun"
  administrator_login_password = azurerm_key_vault_secret.db_info.value
  version                      = "11"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "db" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.store.name
  server_name         = azurerm_postgresql_server.dbServer.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
resource "azurerm_private_endpoint" "example" {
  name = "${var.db_name_prefix}-${random_string.random.result}-endpoint"
  location = var.location
  resource_group_name = azurerm_resource_group.store.name
  subnet_id = azurerm_subnet.k8s-internal.id
  private_service_connection {
    name                           = "${random_string.random.result}-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.dbServer.id
    subresource_names              = [ "postgresqlServer" ]
    is_manual_connection           = false
  }
}
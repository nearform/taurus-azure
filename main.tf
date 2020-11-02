provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  subscription_id = var.sub_id
  features {}
}
resource "random_string" "random" {
  length = 8
  min_lower = 8
  special = false
  override_special = "/@£$"
}
provider "kubernetes" {
  alias = "admin"
  load_config_file       = "false"
  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  username               = azurerm_kubernetes_cluster.k8s.kube_config.0.username
  password               = azurerm_kubernetes_cluster.k8s.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}
provider "postgresql" {
  host            = azurerm_postgresql_server.dbServer.fqdn
  port            = 5432
  database        = azurerm_postgresql_database.db.name
  username        = azurerm_key_vault_secret.db_admin.name
  password        = azurerm_key_vault_secret.db_admin.value
  sslmode         = "require"
  connect_timeout = 15
}
output "cluster_username" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.username
}
output "cluster_password" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.password
}
output "host" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}
output "ci_user_id" {
  value = azuread_application.app.application_id
}
output "ci_user_password" {
  value     = azuread_application_password.ci-user.value
  sensitive = true
}
output "AKS_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.fqdn
}
output "ACR_name" {
  value = azurerm_container_registry.acr.login_server
}
output "k8s_resource_group" {
  value = azurerm_kubernetes_cluster.k8s.resource_group_name
}
output "db_admin_password" {
  value = azurerm_key_vault_secret.db_admin.value
  sensitive = true
}
output "psql_private_endpoint" {
  value = azurerm_private_endpoint.endpoint.private_service_connection[0].private_ip_address
}
output "tenant_ID" {
  value = data.azurerm_subscription.main.tenant_id
}
output "sub_id" {
  value = data.azurerm_subscription.main.subscription_id
}
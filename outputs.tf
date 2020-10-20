output "cluster_username" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.username
}
output "cluster_password" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.password
}
output "host" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}
output "id" {
  value = azurerm_kubernetes_cluster.k8s.id
}
output "cluster_egress_ip" {
  value = data.azurerm_public_ip.pub.ip_address
}
output "keyvault_id" {
  value = azurerm_key_vault.kv.id
}
output "ci_display_name" {
  value = azuread_service_principal.ci-user.display_name
}
output "ci_client_id" {
  value = azuread_application.app.application_id
}
output "ci_client_secret" {
  value     = azuread_application_password.ci-user.value
  sensitive = true
}
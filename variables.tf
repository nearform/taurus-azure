variable "environment" {
  description = "Environment i.e. dev"
}
variable "namespace" {
  description = "Namespace which allows identifying resources i.e. xyz"
}
variable "sub_id" {
  description = "Azure Subscription ID"
}
variable "location" {
  description = "Region where the resources are created"
}
variable "agent_count" {
    default = 3
}
variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}
variable "aks_dns_prefix" {
}
variable cluster_name {
}
variable acr_name {
  description = "5 or more alphanumeric characters"
}
variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}
# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
}
# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
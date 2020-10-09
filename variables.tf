variable "environment" {
  description = "Environment i.e. dev"
}
variable "full_name" {
  description = "Fullname, will add as a tag to resources"
}
variable "namespace" {
  description = "Namespace which allows identifying resources i.e. xyz"
}
variable "sub_id" {
  description = "Azure Subscription ID"
}
variable "client_id" {
  description = "Azure client ID"
}
variable "tenant_id" {
  description = "Azure tenant ID"
}
variable "client_secret" {
  description = ""
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

variable "dns_prefix" {

}

variable cluster_name {
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
  default = var.location
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
data "azurerm_subscription" "main" {}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.acr_name_prefix}${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.k8s.name
  location                 = var.location
  sku                      = "Standard"
  admin_enabled            = false
}
# Create Application
resource "azuread_application" "app" {
  name = "GitHubActionsUser"
}

# Create Service Principal linked to the Application
resource "azuread_service_principal" "ci-user" {
  application_id = azuread_application.app.application_id
}

# Generate random password to be used for Application password (client secret)
resource "random_password" "example" {
  length  = 32
  special = true
}

# Create Application password (client secret)
resource "azuread_application_password" "ci-user" {
  application_object_id = azuread_application.app.object_id
  value                 = random_password.example.result
  end_date_relative     = "17520h" # expire in 2 years
}

# Create role assignment for Service Principal
resource "azurerm_role_assignment" "AcrPush" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.ci-user.id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.ci-user.id
  skip_service_principal_aad_check = true
}
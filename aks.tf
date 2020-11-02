resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${module.labels.id}-aks"
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = "${module.labels.id}-aks"
    sku_tier            = "Free"

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }
    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = var.default_node_pool_vm_size
        vnet_subnet_id = azurerm_subnet.k8s-internal.id
    }

  identity {
    type = "SystemAssigned"
  }

    addon_profile {
        oms_agent {
            enabled = true
            log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
        }
        kube_dashboard {
            enabled = true
    }
    }

    network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "kubenet"
    }

    tags = {
        Environment = var.environment
    }
}
# Create a Service Account
resource "kubernetes_service_account" "app" {
  provider = kubernetes.admin
  automount_service_account_token = true
  depends_on = [azurerm_kubernetes_cluster.k8s]
  metadata {
    name = "app"
  }
  secret {
    name = kubernetes_secret.secret.metadata.0.name
  }
}

# Add the Secret, that holds the Service Account Token as a data source
resource "kubernetes_secret" "secret" {
  provider = kubernetes.admin

  metadata {
    name = "app-secret"
  }
  data = {
    PGHOST                   = azurerm_postgresql_server.dbServer.fqdn
    PGPORT                   = "5432"
    PGDATABASE               = azurerm_postgresql_database.db.name
    PGUSER                   = azurerm_key_vault_secret.db_admin.name
    PGPASSWORD               = azurerm_key_vault_secret.db_admin.value
  }

  type = "Opaque"
}

# Create a new Role for the Service Account
resource "kubernetes_cluster_role" "app" {
  provider = kubernetes.admin
  metadata {
    name = "app"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "update", "create", "patch"]
  }
}

# Assign the Role to the Service Account
resource "kubernetes_cluster_role_binding" "app-user" {
  provider = kubernetes.admin

  metadata {
    name = "app"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.app.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.app.metadata[0].name
  }
}
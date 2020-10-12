resource "azurerm_resource_group" "k8s" {
    name     = azurerm_resource_group.prod.name
    location = var.location
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.k8s.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = azurerm_resource_group.k8s.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${module.labels.id}-aks"
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = "${module.labels.id}-aks"

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2_v2"
        vnet_subnet_id = azurerm_virtual_network.default.id
    }

  identity {
    type = "SystemAssigned"
  }

    addon_profile {
        oms_agent {
            enabled = true
            log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
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
        Environment = "Development"
    }
}
resource "azurerm_kubernetes_cluster_node_pool" "user_pool" {
    name = "user"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
    vm_size = "Standard_DS2_v2"
    node_count = 1
    vnet_subnet_id = azurerm_subnet.internal.id
}
data "azurerm_public_ip" "pub" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.k8s.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
}
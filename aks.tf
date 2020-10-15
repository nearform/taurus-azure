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

data "azurerm_public_ip" "pub" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.k8s.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
}
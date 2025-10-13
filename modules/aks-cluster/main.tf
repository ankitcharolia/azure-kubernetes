resource "azurerm_resource_group" "this" {
  name     = "rg-aks-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "aks-identity"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "aks-log-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data "azurerm_client_config" "this" {}
data "azuread_group" "admin_group" {
  display_name     = "ADMIN"
  security_enabled = true
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.environment}-cluster"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  # kubernetes_version
  kubernetes_version = var.aks_kubernetes_version

  private_cluster_enabled = true
  local_account_disabled  = true

  # Enable OIDC - required for Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Enable Azure Policy (Important for security and compliance)
  azure_policy_enabled = true
  sku_tier             = var.aks_sku_tier

  # Enable Cost Analysis (requires Azure Cost Management + Billing)
  cost_analysis_enabled = true

  default_node_pool {
    name                         = "default"
    max_pods                     = 100
    only_critical_addons_enabled = true
    auto_scaling_enabled         = true
    orchestrator_version         = var.aks_kubernetes_version
    node_count                   = var.aks_default_pool_initial_node_count
    min_count                    = var.aks_default_pool_size_min_count
    max_count                    = var.aks_default_pool_size_max_count
    type                         = "VirtualMachineScaleSets"
    vm_size                      = var.aks_default_pool_vm_size
    vnet_subnet_id               = var.aks_subnet_id
    zones                        = var.aks_availability_zones
    temporary_name_for_rotation  = "tmppool"

    upgrade_settings {
      max_surge = "2"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  # Enable RBAC
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    tenant_id = data.azurerm_client_config.this.tenant_id
    # Azure AD Group with admin privileges
    admin_group_object_ids = [data.azuread_group.admin_group.object_id]
    azure_rbac_enabled     = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  # use separate IP addresses for Pods and Services 
  network_profile {
    network_plugin      = "azure"
    network_policy      = "azure"
    network_plugin_mode = "overlay"
    service_cidr        = var.aks_service_cidr
    pod_cidr            = var.aks_pod_cidr
  }

  # Limit API server access to specific IP ranges
  api_server_access_profile {
    authorized_ip_ranges = var.aks_authorized_ip_ranges
  }

  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = 23
    }
  }

  maintenance_window_node_os {
    frequency  = "Weekly"
    interval   = 4
    start_time = "00:00"
    duration   = 8
  }

  maintenance_window_auto_upgrade {
    frequency  = "Weekly"
    interval   = 1
    start_time = "00:00"
    duration   = 8
  }

  tags = var.tags

  lifecycle {
    ignore_changes  = [node_count]
    prevent_destroy = true
  }

  depends_on = [
    azurerm_log_analytics_workspace.this,
    azurerm_user_assigned_identity.this,
    azurerm_resource_group.this
  ]
}

# Create Node Pools
resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = { for node_pool in var.aks_node_pools : node_pool.name => node_pool }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  auto_scaling_enabled  = true
  priority              = try(each.value.spot_node_pool, true) ? "Spot" : "Regular"
  eviction_policy       = "Delete"
  min_count             = try(each.value.min_node_count, 1)
  max_count             = each.value.max_node_count
  node_count            = try(each.value.initial_node_count, 1)
  max_pods              = 100
  orchestrator_version  = try(each.value.orchestrator_version, var.aks_kubernetes_version)
  vm_size               = each.value.node_pool_vm_size
  os_disk_type          = try(each.value.spot_node_pool, true) ? "Ephemeral" : "Managed"
  vnet_subnet_id        = var.aks_subnet_id
  zones                 = var.aks_availability_zones

  node_labels = merge(var.node_pool_labels, {
    cluster = "${azurerm_kubernetes_cluster.this.id}"
  })

  dynamic "node_taints" {
    for_each = try(each.value.node_taints, null) != null ? each.value.node_taints : []
    content {
      value = node_taints.value
    }
  }

  upgrade_settings {
    max_surge = try(each.value.max_surge, "1")
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [node_count]
    # create_before_destroy = true
  }

  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
}


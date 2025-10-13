module "aks_cluster" {
  source = "./modules/aks-cluster"

  aks_subnet_id            = module.vnet.aks_subnet_id
  environment              = var.environment
  location                 = var.location
  tags                     = var.tags
  aks_kubernetes_version   = var.kubernetes_version
  aks_sku_tier             = var.aks_sku_tier
  aks_authorized_ip_ranges = var.aks_authorized_ip_ranges
  aks_node_pools           = var.aks_node_pools

  depends_on = [
    module.vnet
  ]
}
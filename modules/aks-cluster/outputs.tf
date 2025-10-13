## Reference: 
# https://medium.com/h7w/deploying-your-aks-cluster-with-terraform-key-points-for-a-successful-production-rollout-e92f1238906f
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "kube_endpoint" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].host
  sensitive = true
}

output "kube_username" {
  value = azurerm_kubernetes_cluster.this.kube_config[0].username
}

output "kube_password" {
  value = azurerm_kubernetes_cluster.this.kube_config[0].password
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_key
  sensitive = true
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "aks_rg_id" {
  value = azurerm_resource_group.this.id
}
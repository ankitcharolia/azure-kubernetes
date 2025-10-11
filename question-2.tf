# deploy helm chart
resource "helm_release" "shop_backend_api" {
  name              = "shop-backend-api"
  namespace         = "default"
  chart             = "./chart/shop-backend-api"
  dependency_update = true
  force_update      = true
  create_namespace  = true
  atomic            = true
  wait              = true
  cleanup_on_fail   = true
  max_history       = 5
  timeout           = 600

  depends_on = [ 
    azurerm_kubernetes_cluster.this, 
  ]
}
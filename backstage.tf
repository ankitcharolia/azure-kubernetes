# deploy backstage
resource "helm_release" "backstage" {
  name              = "backstage"
  namespace         = "default"
  chart             = "backstage"
  repository       = "https://backstage.github.io/charts"
  version          = var.backstage_chart_version
  dependency_update = true
  force_update      = true
  create_namespace  = true
  atomic            = true
  wait              = true
  cleanup_on_fail   = true
  max_history       = 5
  timeout           = 600
  values = [
    file("./charts/backstage/${var.environment}-values.yaml")
  ]

  depends_on = [
    azurerm_kubernetes_cluster.this,
  ]
}
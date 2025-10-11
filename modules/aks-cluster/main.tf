resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-rg"
  location = "westeurope"
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "test-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
    tags = {
        Environment = "test"
        managedBy   = "terraform"
        Team        = "devops"
    }
}
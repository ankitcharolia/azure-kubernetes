terraform {
  required_version = ">= 1.13.3"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "this" {
  name                = module.aks_cluster.cluster_id
  resource_group_name = module.aks_cluster.aks_rg_id
  depends_on = [
    module.aks_cluster,
  ]
}

provider "kubernetes" {
  host                   = module.aks.kube_endpoint
  username               = module.aks.kube_username
  password               = module.aks.kube_password
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
}

provider "helm" {
  kubernetes = {
    host                   = module.aks.kube_endpoint
    username               = module.aks.kube_username
    password               = module.aks.kube_password
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
  }
}

provider "kubectl" {
  host                   = module.aks.kube_endpoint
  username               = module.aks.kube_username
  password               = module.aks.kube_password
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
}


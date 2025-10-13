# common variables
environment = test
location    = westeurope
tags = {
  environment = "test"
  managedBy   = "terraform"
  department  = "SRE"
}

# VPC variables
azure_nat_address_count      = 1
vnet_address_space           = ["10.0.0.0/16"]
kube_subnet_address_prefixes = ["10.0.0.0/24"]
vm_subnet_address_prefixes   = ["10.0.1.0/24"]

# AKS cluster variables
kubernetes_version = "1.34"
aks_sku_tier       = "Free"

aks_authorized_ip_ranges = [
  "x.x.x.x/24",
]

aks_node_pools = [
  {
    name               = "main"
    spot_node_pool     = false
    initial_node_count = 1
    min_node_count     = 1
    max_node_count     = 5

    labels = {
      role = "main"
    }
    max_surge         = "1"
    node_pool_vm_size = ["Standard_D4s_v3"]
  },
  {
    name               = "gitlab-runner"
    spot_node_pool     = true
    initial_node_count = 1
    min_node_count     = 0
    max_node_count     = 5

    labels = {
      role = "spot"
    }

    node_taints = [
      "spot=true:NoSchedule",
      "gitlab-runner=true:NoSchedule"
    ]
    max_surge         = "2"
    node_pool_vm_size = ["Standard_D4s_v3"]
  }
]
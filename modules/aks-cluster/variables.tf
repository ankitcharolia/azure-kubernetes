variable "location" {
  description = "The Azure region to deploy resources in."
  type        = string
}

variable "environment" {
  description = "The environment to deploy resources in."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "aks_kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
}

variable "aks_default_pool_vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
  default     = "Standard_D4s_v3"
}

variable "aks_default_pool_initial_node_count" {
  description = "The initial number of nodes which should exist in the default node pool."
  type        = number
  default     = 2
}

variable "aks_default_pool_size_min_count" {
  description = "The minimum number of nodes which should exist in the default node pool."
  type        = number
  default     = 1
}

variable "aks_default_pool_size_max_count" {
  description = "The maximum number of nodes which should exist in the default node pool."
  type        = number
  default     = 5
}

variable "aks_availability_zones" {
  description = "A list of availability zones for the default node pool."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "aks_subnet_id" {
  description = "The ID of the Subnet to deploy the AKS cluster into."
  type        = string
}

variable "aks_service_cidr" {
  description = "The CIDR notation IP range from which to assign service cluster IPs."
  type        = string
  default     = "10.10.0.0/16"
}

variable "aks_pod_cidr" {
  description = "The CIDR notation IP range from which to assign pod IPs."
  type        = string
  default     = "10.20.0.0./16"
}

variable "aks_node_pools" {
  type        = any
  description = "A list of maps containing the configuration for each additional node pool."
  default     = []
}

variable "node_pool_labels" {
  description = "A map of labels to apply to the node pool."
  type        = map(string)
  default     = {}
}

variable "aks_sku_tier" {
  description = "The SKU tier of the AKS cluster. Possible values are 'Free', 'Standard' and 'Premium'."
  type        = string
}

variable "aks_authorized_ip_ranges" {
  description = "A list of authorized IP ranges to access the AKS API server."
  type        = list(string)
  default     = []
}





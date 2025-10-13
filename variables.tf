variable "location" {
  description = "The Azure region to deploy resources into."
  type        = string
}

variable "environment" {
  description = "The environment to deploy resources into."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
}

variable "aks_sku_tier" {
  description = "The SKU tier of the AKS cluster."
  type        = string
  default     = "Free"
}

variable "aks_authorized_ip_ranges" {
  description = "The list of authorized IP ranges to access the AKS API server."
  type        = list(string)
  default     = []
}

variable "aks_node_pools" {
  description = "A list of maps defining the node pools for the AKS cluster."
  type        = any
  default     = []
}

variable "azure_nat_address_count" {
  description = "The number of public IP addresses to create for the NAT Gateway."
  type        = number
}

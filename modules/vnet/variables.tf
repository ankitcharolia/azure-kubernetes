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

variable "vnet_availability_zones" {
  description = "A list of availability zones for the resources."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "azure_nat_address_count" {
  description = "The number of public IP addresses to create for the NAT Gateway."
  type        = number
  default     = 1
}
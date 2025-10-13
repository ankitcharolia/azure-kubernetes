module "vnet" {
  source = "./modules/vnet"

  location                     = var.location
  environment                  = var.environment
  tags                         = var.tags
  azure_nat_address_count      = var.azure_nat_address_count
  vnet_address_space           = var.vnet_address_space
  kube_subnet_address_prefixes = var.kube_subnet_address_prefixes
  vm_subnet_address_prefixes   = var.vm_subnet_address_prefixes
}
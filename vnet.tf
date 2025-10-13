module "vnet" {
  source = "./modules/vnet"

  location                = var.location
  environment             = var.environment
  tags                    = var.tags
  azure_nat_address_count = var.azure_nat_address_count
}
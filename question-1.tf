# create resource group
resource "azurerm_resource_group" "this" {
  name     = "sre-challenge-flaschenpost"
  location = "westeurope"

  tags = {
    department = "SRE"
  }
}

# Azure Storage Account
resource "azurerm_storage_account" "this" {
  name                     = "srechallengeflaschenpost"   # 3-24 character long only
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # Locally-redundant storage 
  access_tier              = "Hot"

  tags = {
    department = "SRE"
  }
}

# Azure Storage Container (S3 bucket)
resource "azurerm_storage_container" "this" {
    name                  = "sre"
    storage_account_id  = azurerm_storage_account.this.id
    container_access_type = "private"
}

## output variables in outputs.tf file ## 

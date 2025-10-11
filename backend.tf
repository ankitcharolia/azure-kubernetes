terraform {
  required_version = ">= 1.13.3"
  
  backend "local" {
    path = "./terraform.tfstate"
  }
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }
}

provider "azurerm" {
  features {}
}
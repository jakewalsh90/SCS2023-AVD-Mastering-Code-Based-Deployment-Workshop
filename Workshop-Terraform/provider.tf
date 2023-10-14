# Providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
# Provider Config
provider "azurerm" {
  # Configuration options
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
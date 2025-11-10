terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }
  subscription_id = "ffa2837b-7ffe-444a-bab6-a45fc3eff8fc"
}
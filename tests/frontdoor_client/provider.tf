terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.52.0"
    }

  }

  backend "azurerm" {
    resource_group_name  = resource_group_name
    storage_account_name = storage_account_name
    container_name       = container_name
    key                  = key
  }

}

provider "azurerm" {
  features {}
  subscription_id = subscription_id
}

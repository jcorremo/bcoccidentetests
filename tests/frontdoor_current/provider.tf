terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.52.0"
    }

  }

  backend "azurerm" {
    resource_group_name  = "TFSTATE"
    storage_account_name = "iacgralstatepocdeployer"
    container_name       = "iacgralstate"
    key                  = "local.deployment.frontdoor.manager.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
  subscription_id = "0bea0a37-89cb-43fb-976f-0d8a3d8b1e4b"
}

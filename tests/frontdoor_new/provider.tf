terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.55.0"
    }

  }

  backend "azurerm" {
    resource_group_name  = "TFSTATE"
    storage_account_name = "iacgralstatepocdeployer"
    container_name       = "iacgralstate"
    key                  = "local.deployment.front_testv.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
  alias           = "sasdasd"
  subscription_id = "0bea0a37-89cb-43fb-976f-0d8a3d8b1e4b"
}

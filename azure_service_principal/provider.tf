# Providers
# Description: Configures the required providers for the Terraform configuration.

terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.55.0"
    }
  }

  required_version = "1.4.6"
}

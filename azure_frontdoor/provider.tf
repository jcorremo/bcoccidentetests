# Providers
# Description: Configures the required providers for the Terraform configuration.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.52.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
    }

  }
  required_version = "1.4.6"
}
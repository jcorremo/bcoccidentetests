terraform {
  required_version = ">= 0.14.0"
  #experiments      = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.40.0"
    }
  }
}

variable "resource_group_name" {
  description = "The name of the resource group where the infrastructure will be deployed."
  type        = string
}

variable "front_door_sku_name" {
  type        = string
  description = "The SKU name of the Azure Front Door."

  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.front_door_sku_name)
    error_message = "Invalid SKU name. Please provide either 'Standard_AzureFrontDoor' or 'Premium_AzureFrontDoor'."
  }
}


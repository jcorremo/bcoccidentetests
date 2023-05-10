variable "resource_group_location" {
  description = "Physical location of resource group"
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

variable "tags" {
  type = object({
    environment          = string
    name_app             = string
    business_domain      = string
    service_domain       = string
    business_area        = string
    organizational_units = string
    name_service         = string
    cost                 = string
  })
  description = "(Required) Tags to apply to all resources created."
  sensitive   = false
}



variable "frontdoor_origin_groups" {
  description = "Specifies the list of frontdoor origin groups."
  type = list(object({
    session_affinity_enabled = optional(bool)
    load_balancing = object({
      additional_latency_in_milliseconds = optional(number)
      sample_size                        = optional(number)
      successful_samples_required        = optional(number)
    })

    health_probe = optional(object({
      protocol            = string
      interval_in_seconds = number
      request_type        = optional(string)
      path                = optional(string)
    }))

    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number)

    azurerm_cdn_frontdoor_origins = list(object({
      host_name                      = string
      certificate_name_check_enabled = bool
      enabled                        = optional(bool)
      http_port                      = optional(string)
      https_port                     = optional(string)
      origin_host_header             = optional(string)
      priority                       = optional(number)
      weight                         = optional(number)
    }))

  }))
  default = []
}


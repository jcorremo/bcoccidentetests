# Variable: resource_group_name
# Description: The name of the resource group where the infrastructure will be deployed.
variable "resource_group_name" {
  description = "The name of the resource group where the infrastructure will be deployed."
  type        = string
}

# Variable: front_door_sku_name
# Description: The SKU name of the Azure Front Door.
# Type: string
# Validation: Ensures the SKU name is either 'Standard_AzureFrontDoor' or 'Premium_AzureFrontDoor'.
variable "front_door_sku_name" {
  type        = string
  description = "The SKU name of the Azure Front Door."

  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.front_door_sku_name)
    error_message = "Invalid SKU name. Please provide either 'Standard_AzureFrontDoor' or 'Premium_AzureFrontDoor'."
  }
}

# Variable: tags
# Description: Tags to apply to all resources created.
# Type: object
# Attributes:
#   - environment (string): Environment name.
#   - name_app (string): Application name.
#   - business_domain (string): Business domain.
#   - service_domain (string): Service domain.
#   - business_area (string): Business area.
#   - organizational_units (string): Organizational units.
#   - name_service (string): Service name.
#   - cost (string): Cost information.
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


# Variable: frontdoor_origin_groups
# Description: Specifies a list of frontdoor origin groups.
# Type: list(object)
# Attributes:
#   - session_affinity_enabled (bool): Indicates whether session affinity is enabled for the origin group.
#   - load_balancing (object): Specifies the load balancing configuration for the origin group.
#     - additional_latency_in_milliseconds (number): Additional latency in milliseconds to apply to each request.
#     - sample_size (number): Number of requests to sample for load balancing.
#     - successful_samples_required (number): Number of successful samples required for considering a backend healthy.
#   - health_probe (object): Specifies the health probe configuration for the origin group.
#     - protocol (string): Protocol to use for health probes. Valid values are "http" or "https".
#     - interval_in_seconds (number): Interval between health probes in seconds.
#     - request_type (string): Type of request to use for health probes. Valid values are "GET" or "HEAD".
#     - path (string): Path to use for health probes.
#   - restore_traffic_time_to_healed_or_new_endpoint_in_minutes (number): Time in minutes to restore traffic to a healed or new endpoint.
#   - azurerm_cdn_frontdoor_origins (list(object)): Specifies the list of frontdoor origins for the origin group.
#     - host_name (string): The hostname or IP address of the origin.
#     - certificate_name_check_enabled (bool): Indicates whether to enable certificate name checking during SSL/TLS negotiation.
#     - enabled (bool): Indicates whether the origin is enabled for the origin group.
#     - http_port (string): The HTTP port used to communicate with the origin. Defaults to "80" if not specified.
#     - https_port (string): The HTTPS port used to communicate with the origin. Defaults to "443" if not specified.
#     - origin_host_header (string): The host header to send to the origin.
#     - priority (number): The priority of the origin in the origin group. Lower values indicate higher priority.
#     - weight (number): The weight of the origin in the origin group for load balancing. Higher values receive more traffic.

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

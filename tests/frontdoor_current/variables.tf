variable "resource_group_location" {
  default     = "East US 2"
  description = "Location of the resource group."
}

variable "tags" {
  type = object({
    environment          = string # (Required) tipo de ambiente
    name_app             = string # (Required) nombre de la aplicacion
    business_domain      = string # (Required) proceso de negocio al cual esta asociada la aplicacion
    service_domain       = string # (Required) proceso de negocio al cual esta asociada la aplicacion
    business_area        = string # (Required) area de negocio a la cual pertenece la aplicacion
    organizational_units = string # (Required) unidad organizacional a la cual pertenece la  aplicacion
    name_service         = string # (Required) nombre del tipo de servicio desplegado
    cost                 = string # (Required) aplicacion asociado a su control de costos
    app_code             = string # (Required) codigo de la aplicacion
  })
  description = "(Required) Tags to apply to all resources created."
  sensitive   = false
}

variable "backend_pool_health_probe" {
  type = list(object({
    name                = string           # (Required) Specifies the name of the Health Probe.
    enabled             = optional(bool)   # (Optional) Is this health probe enabled? Dafaults to true.
    path                = optional(string) # (Optional) The path to use for the Health Probe. Default is /.
    protocol            = optional(string) # (Optional) Protocol scheme to use for the Health Probe. Defaults to Http.
    probe_method        = optional(string) # (Optional) Specifies HTTP method the health probe uses when querying the backend pool instances. Possible values include: Get and Head. Defaults to Get.
    interval_in_seconds = optional(number) # (Optional) The number of seconds between each Health Probe. Defaults to 120.
  }))
  description = "(Required) A backend_pool_health_probe block as defined below."
}
#----------------------------------------------
# Frontdoor Backend Load Balancing Creation
#----------------------------------------------
variable "backend_pool_load_balancing" {
  type = list(object({
    name                            = string           # (Required) Specifies the name of the Load Balancer.
    sample_size                     = optional(number) # (Optional) The number of samples to consider for load balancing decisions. Defaults to 4.
    successful_samples_required     = optional(number) # (Optional) The number of samples within the sample period that must succeed. Defaults to 2.
    additional_latency_milliseconds = optional(number) # (Optional) The additional latency in milliseconds for probes to fall into the lowest latency bucket. Defaults to 0.
  }))
  description = "(Required) A backend_pool_load_balancing block as defined below."
}

variable "name_routing_rule" {
  type = object({
    name_routing_website             = string # (Required) tipo de ambiente
    name_routing_redirecthttptohttps = string # (Required) area de negocio a la cual pertenece la aplicacion
  })
  description = "(Required) name_routing_rule created."
  sensitive   = false
}

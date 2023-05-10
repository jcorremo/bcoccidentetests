variable "name" {
  description = "Client name/account used in naming"
  type        = string
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}
variable "enforce_backend_pools_certificate_name_check" { # required but default value ...
  description = "Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests."
  type        = bool
  default     = false
}
variable "backend_pools_send_receive_timeout_seconds" {
  description = "Specifies the send and receive timeout on forwarding request to the backend"
  type        = number
  default     = 60
}
variable "enable_default_routing_rule" {
  description = "Use the module default routing_rule block."
  type        = bool
  default     = true
}
variable "enable_default_frontend_endpoint" {
  description = "Use the module default frontend_endpoint block."
  type        = bool
  default     = true
}
variable "web_application_firewall_policy_link_id" {
  description = "Frontdoor WAF Policy ID"
  type        = string
  default     = null
}
variable "backend_pool_load_balancings" { # required
  description = "A list of backend_pool_load_balancing blocks."
  type        = list(map(string)) # name = string                            # required
  #                               # sample_size = number                     # optional defaults to 4
  #                               # successful_samples_required = number     # optional defaults to 2
  #                               # additional_latency_milliseconds = number # defaults to 0
  default = [{ "default" = "default" }] # fake list of map, if enable_default_backend_pools_parameters take default lb values
}
variable "backend_pool_health_probes" { # required
  description = "A list of backend_pool_health_probe blocks."
  type        = list(map(string)) # name = string         # required
  #                               # enabled = bool        # optional defaults to true
  #                               # path = string         # optional defaults to /
  #                               # protocol = string     # optional defaults to Http
  #                               # probe_method = string # optional defaults to Get
  default = [{ "default" = "default" }] # fake list of map, if enable_default_backend_pools_parameters take default probe values
}

variable "backend_pools" {
  description = "A list of backend_pool blocks."
  type        = list(any)
  #type = list(object({
  #  name = string          # required
  #  backend = object({     # required
  #    enabled     = bool   # optional defaults to true
  #    address     = string # required
  #    host_header = string # required
  #    http_port   = number # required module-defaults to 80
  #    https_port  = number # required module-defaults to 443
  #    priority    = number # optional defaults to 1
  #    weight      = number # optional defaults to 50
  #  })
  #  load_balancing_name = string # required
  #  health_probe_name   = string # required
  #}))
}




variable "tag_environment" {
  default     = ""
  description = "Variable para etiquetar los recursos con el tipo de ambiente"
}
variable "tag_name_app" {
  default     = ""
  description = "Variable para etiquetar los recursos con el nombre de la aplicacion"
}
variable "tag_business_domain" {
  default     = ""
  description = "Variable para etiquetar los recursos con el tipo de proceso de negocio al cual esta asociada la aplicacion"
}
variable "tag_service_domain" {
  default     = ""
  description = "Variable para etiquetar los recursos con el tipo de proceso de negocio al cual esta asociada la aplicacion"
}
variable "tag_business_area" {
  default     = ""
  description = "Variable para etiquetar los recursos con el nombre del area de negocio a la cual pertenece la aplicacion"
}
variable "tag_organizational_units" {
  default     = ""
  description = "Variable para etiquetar los recursos con el nombre de la unidad organizacional a la cual pertenece la  aplicacion"
}
variable "tag_name_service" {
  default     = "frontdoor"
  description = "Variable para etiquetar los recursos con el nombre del tipo de servicio desplegado"
}
variable "tag_cost" {
  default     = ""
  description = "Variable para etiquetar los recursos con el nombre de la aplicacion asociado a su control de costos"
}

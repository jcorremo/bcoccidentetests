variable "name" {
  type        = string
  description = "(Required) nombre del recurso"
}
variable "location" {
  type        = string
  description = "(Required) nombre de la region donde se desplegara el recurso"
}
variable "resource_group_name" {
  type        = string
  description = "(Required) nombre del grupo de recursos el donde estara alojado el recurso"
}
variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}
variable "subnet_list_obj" {
  description = "List of the databases configurations for this server."
  type = list(object({
    name                                          = string 
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string))
    private_endpoint_network_policies_enabled     = optional(bool) 
    private_link_service_network_policies_enabled = optional(bool) 
    delegation                                    = optional(list(object({
		  name                                        = string
      service_delegation_name                     = string
			service_delegation_actions                  = optional(list(string))
      })))
#    service_delegation                            = optional(list(object({
#				})))
	}))
    default = []
}
variable "tags" {
  type = object({
    environment           = string # (Required) tipo de ambiente e.g. "prod","dev","qa"
    name_app              = string # (Required) nombre de la aplicacion
    business_domain       = string # (Required) proceso de negocio al cual esta asociada la aplicacion
    service_domain        = string # (Required) proceso de negocio al cual esta asociada la aplicacion
    business_area         = string # (Required) area de negocio a la cual pertenece la aplicacion e.g. "critical_mision", "business_support", "analytical_mngmt", "shared_services", "sales&services","n/a"
    organizational_units  = string # (Required) unidad organizacional a la cual pertenece la  aplicacion e.g. "business_area", "management"
    name_service          = optional (string) # nombre del tipo de servicio desplegado
    cost                  = string # (Required) aplicacion asociado a su control de costos
    app_code              = string # (Required) codigo de la aplicacion
  })
  validation {
    condition = contains(["prod","dev","qa"], var.tags.environment)
    error_message = "El valor para el tag bdo_environment no es válido."
  }
  validation {
    condition = contains([ "business_area", "management"], var.tags.organizational_units)
    error_message = "El valor para el tag bdo_organizational_unit no es válido."
  }
  validation {
    condition = contains(["critical_mision", "business_support", "analytical_mngmt", "shared_services", "sales&services","n/a"], var.tags.business_area)
    error_message = "El valor para el tag bdo_business_area no es válido."
  }
	description = "(Required) Tags to apply to all resources created."
    sensitive   = false
}
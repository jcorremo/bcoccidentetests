variable "name" {
  description = "Client name/account used in naming"
  type        = string
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}
variable "enable_waf" {
  description = "Enable WAF on Front Door"
  type        = bool
  default     = true
}
variable "waf_mode" {
  description = "The firewall policy mode. Possible values are Detection, Prevention."
  type        = string
  default     = "Prevention"
}
variable "custom_block_response_status_code" {
  description = "If a custom_rule block's action type is block, this is the response status code. Possible values are 200, 403, 405, 406, or 429."
  type        = number
  default     = 403
}
variable "custom_block_response_body" {
  description = "If a custom_rule block's action type is block, this is the response body. The body must be specified in base64 encoding."
  type        = string
  default     = "PGh0bWw+PGhlYWQ+PHRpdGxlPllvdSBhcmUgYmxvY2tlZCE8L3RpdGxlPjwvaGVhZD48Ym9keSBiZ2NvbG9yPSJibHVlIj48cD48L3A+PHA+PGgxPjxzdHJvbmc+WW91ciByZXF1ZXN0IHdhcyBibG9ja2VkLjwvc3Ryb25nPjwvaDE+PC9wPjwvYm9keT48L2h0bWw+"
}
variable "tag_environment"{
	default =  ""
	description = "Variable para etiquetar los recursos con el tipo de ambiente"
}
variable "tag_name_app"{
	default = ""
	description = "Variable para etiquetar los recursos con el nombre de la aplicacion"
}
variable "tag_business_domain"{
	default = ""
	description = "Variable para etiquetar los recursos con el tipo de proceso de negocio al cual esta asociada la aplicacion"
}
variable "tag_service_domain"{
	default = ""
	description = "Variable para etiquetar los recursos con el tipo de proceso de negocio al cual esta asociada la aplicacion"
}
variable "tag_business_area"{
	default = ""
	description = "Variable para etiquetar los recursos con el nombre del area de negocio a la cual pertenece la aplicacion"
}
variable "tag_organizational_units"{
	default = ""
	description = "Variable para etiquetar los recursos con el nombre de la unidad organizacional a la cual pertenece la  aplicacion"
	}
variable "tag_name_service"{
	default = "frontdoor_firewall_policy"
	description = "Variable para etiquetar los recursos con el nombre del tipo de servicio desplegado"
}
variable "tag_cost"{
	default = ""
	description = "Variable para etiquetar los recursos con el nombre de la aplicacion asociado a su control de costos"
}
variable "managed_rule" {
  type = object({
    type		= string # (Optional) 
    version		= string # (Optional) 
  })
  description = "(Optional)Variable para adicionar datos para segunda regla del waf "
  sensitive   = false
  default     = null
}
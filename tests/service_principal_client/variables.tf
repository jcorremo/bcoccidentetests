#
# Old configuration
#
#variable "name" {
#  description = "Client name/account used in naming"
#  type        = string
#}
#variable "location" {
#  description = "Azure location."
#  type        = string
#}
#variable "resource_group_name" {
#  description = "Resource group name"
#  type        = string
#}
#variable "kind" {
#  description = "The kind of the App Service Plan to create. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html#kind"
#  type        = string
#}
#variable "reserved" {
#  description = "Flag indicating if App Service Plan should be reserved. Forced to true if \"kind\" is \"Linux\"."
#  type        = string
#  default     = "false"
#}
#variable "sku" {
#  description = "A sku block. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html#sku"
#  type        = map(string)
#}
#variable "tag_environment" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el tipo de ambiente"
#}
#variable "tag_name_app" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el nombre de la aplicacion"
#}
#variable "tag_business_domain" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el tipo de proceso de negocio al cual esta asociada la aplicacion"
#}
#variable "tag_service_domain" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el tipo de proceso de negocio al cual esta asociada la aplicacion"
#}
#variable "tag_business_area" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el nombre del area de negocio a la cual pertenece la aplicacion"
#}
#variable "tag_organizational_units" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el nombre de la unidad organizacional a la cual pertenece la  aplicacion"
#}
#variable "tag_name_service" {
#  default     = "storage_account"
#  description = "Variable para etiquetar los recursos con el nombre del tipo de servicio desplegado"
#}
#variable "tag_cost" {
#  default     = ""
#  description = "Variable para etiquetar los recursos con el nombre de la aplicacion asociado a su control de costos"
#}



# Variable: resource_group_name
# Description: The name of the location to deploy the service plan
variable "service_plan_location" {
  description = "The name of the location to deploy the service plan."
  type        = string
}

variable "resource_group_location" {
  description = "Physical location of resource group"
  type        = string
}

# Variable: os_type
# Description: The O/S type for the App Services to be hosted in this plan. Possible values include Windows, Linux, and WindowsContainer. Changing this forces a new resource to be created.
# Type: string
# Validation: Ensures the OS type is either 'Windows', 'Linux', or 'WindowsContainer'.
variable "os_type" {
  type        = string
  description = "The O/S type for the App Services to be hosted in this plan. Possible values include Windows, Linux, and WindowsContainer. Changing this forces a new resource to be created."

  validation {
    condition     = contains(["Windows", "Linux", "WindowsContainer"], var.os_type)
    error_message = "Invalid OS type. Please provide either 'Windows', 'Linux', or 'WindowsContainer'."
  }
}


# Variable: sku_name
# Description: The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1.
# Type: string
# Validation: Ensures the SKU name is one of the allowed values.
variable "sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."

  validation {
    condition     = contains(["B1", "B2", "B3", "D1", "F1", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "I4v2", "I5v2", "I6v2", "P1v2", "P2v2", "P3v2", "P1v3", "P2v3", "P3v3", "P1mv3", "P2mv3", "P3mv3", "P4mv3", "P5mv3", "S1", "S2", "S3", "SHARED", "EP1", "EP2", "EP3", "WS1", "WS2", "WS3", "Y1"], var.sku_name)
    error_message = "Invalid SKU name. Please provide one of the allowed values: B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, or Y1."
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

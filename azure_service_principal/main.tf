#
# Old configuration
#---------------------------------------------------
# Service Plan creation
#----------------------------------------------------------
#resource "azurerm_app_service_plan" "plan" {
#  name					= var.name 
#  location				= var.location
#  resource_group_name	= var.resource_group_name
#  kind					= var.kind
#  reserved				= var.kind == "Linux" ? true : var.reserved
#  sku {
#    capacity = lookup(var.sku, "capacity", local.default_sku_capacity)
#    size     = lookup(var.sku, "size", null)
#    tier     = lookup(var.sku, "tier", null)
#  }
#     lifecycle {
#    ignore_changes = [
#      kind,
#    ]
#  }
#	tags	= {
#		environment				= var.tag_environment
#		name_app						= var.tag_name_app
#		organizational_units	= var.tag_organizational_units
#		business_area			= var.tag_business_area
#		business_domain			= var.tag_business_domain
#		service_domains			= var.tag_service_domain
#		cost					= var.tag_cost
#		name_service			= var.tag_name_service
#		}
#}

resource "azurerm_service_plan" "azurerm_service_plan_main" {
  # Name of the service plan. Non-alphanumeric characters are removed and the name is truncated to a maximum of 50 characters.
  name = substr(replace(local.azurerm_service_plan_name, "/[^A-Za-z0-9-]/", ""), 0, 50)
  # Name of the resource group where the service plan will be created.
  resource_group_name = var.resource_group_name
  # Location where the service plan will be provisioned.
  location = var.service_plan_location
  # The O/S type for the App Services to be hosted in this plan.
  # Possible values include Windows, Linux, and WindowsContainer.
  os_type = var.os_type
  # The SKU for the service plan.
  # Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1.
  sku_name = var.sku_name
  # Tags to apply to the service plan.
  tags = var.tags
}

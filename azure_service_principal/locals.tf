#
# Old configuration
#
#locals {
# default_sku_capacity = var.sku["tier"] == "Dynamic" ? null : 2
#}

locals {
  azurerm_service_plan_name = "${var.tags.name_app}-svplan-${var.tags.environment}"
}

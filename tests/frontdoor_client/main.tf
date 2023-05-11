resource "azurerm_resource_group" "rg_main" {
  location = var.resource_group_location
  name     = var.tags.name_app
}

module "frontdoor" {
  source = "../../azure_frontdoor"
  providers = {
    azurerm = azurerm
  }
  resource_group_name     = azurerm_resource_group.rg_main.name
  front_door_sku_name     = var.front_door_sku_name
  tags                    = var.tags
  frontdoor_origin_groups = var.frontdoor_origin_groups
}

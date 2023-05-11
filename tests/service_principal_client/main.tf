resource "azurerm_resource_group" "rg_main" {
  location = var.resource_group_location
  name     = var.tags.name_app
}

module "azure_service_principal" {
  source = "../../azure_service_principal"

  providers = {
    azurerm = azurerm
  }

  resource_group_name   = azurerm_resource_group.rg_main.name
  service_plan_location = var.service_plan_location
  os_type               = var.os_type
  sku_name              = var.sku_name
  tags                  = var.tags

}

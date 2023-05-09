locals {
  front_door_profile_name      = "MyFrontDoor"
  front_door_endpoint_name     = "afd-${lower(random_id.front_door_endpoint_name.hex)}"
  front_door_origin_group_name = "MyOriginGroup"
  front_door_origin_name       = "MyAppServiceOrigin"
  front_door_route_name        = "MyRoute"
}


# This resource block provisions an Azure Front Door Profile within the Azure Content Delivery Network (CDN) service.
resource "azurerm_cdn_frontdoor_profile" "front_door" {
  # The name of the Azure Front Door Profile.
  name = local.front_door_profile_name
  # The name of the Azure Resource Group where the Front Door Profile will be created.
  resource_group_name = var.resource_group_name
  # The SKU (Stock Keeping Unit) name for the Front Door Profile.
  sku_name = var.front_door_sku_name
}

# This resource block creates an Azure Front Door Endpoint within the specified Azure Front Door Profile.
resource "azurerm_cdn_frontdoor_endpoint" "front_door_endpoint" {
  # The name of the Azure Front Door Endpoint.
  name = local.front_door_endpoint_name
  # The ID of the Azure Front Door Profile to which the Endpoint belongs.
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
}

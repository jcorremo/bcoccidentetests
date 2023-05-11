locals {

  front_door_profile_name  = "${var.tags.name_app}-fdprofile-${var.tags.environment}"
  front_door_endpoint_name = "${var.tags.name_app}-fdendpoint-${var.tags.environment}"
  front_door_origin_group  = "${var.tags.name_app}-fdgroup-${var.tags.environment}"
  front_door_origin        = "${var.tags.name_app}-fdorigin-${var.tags.environment}"

  azurerm_cdn_frontdoor_origins = flatten([
    for k, v in var.frontdoor_origin_groups : [
      for ik, iv in v.azurerm_cdn_frontdoor_origins : [
        {
          parent_group_index = k,
          child_origin       = iv
        }
      ]
    ]
  ])

}

# This resource block provisions an Azure Front Door Profile within the Azure Content Delivery Network (CDN) service.
resource "azurerm_cdn_frontdoor_profile" "front_door" {
  # The name of the Azure Front Door Profile.
  name = substr(replace(local.front_door_profile_name, "/[^A-Za-z0-9-]/", ""), 0, 50)
  # The name of the Azure Resource Group where the Front Door Profile will be created.
  resource_group_name = var.resource_group_name
  # The SKU (Stock Keeping Unit) name for the Front Door Profile.
  sku_name = var.front_door_sku_name
  #Tags to apply to all resources created
  tags = var.tags
}

# This resource block creates an Azure Front Door Endpoint within the specified Azure Front Door Profile.
resource "azurerm_cdn_frontdoor_endpoint" "front_door_endpoint" {
  # The name of the Azure Front Door Endpoint.
  name = substr(replace(local.front_door_endpoint_name, "/[^A-Za-z0-9-]/", ""), 0, 80)
  # The ID of the Azure Front Door Profile to which the Endpoint belongs.
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
  #Tags to apply to all resources created
  tags = var.tags
}

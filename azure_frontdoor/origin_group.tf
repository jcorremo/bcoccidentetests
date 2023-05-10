# Resource: azurerm_cdn_frontdoor_origin_group
# Description: Manages a CDN Front Door origin group.
resource "azurerm_cdn_frontdoor_origin_group" "front_door_origin_group" {
  for_each                 = { for idx, obj in var.frontdoor_origin_groups : idx => obj }
  name                     = "${local.front_door_origin_group}-${each.key}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
  session_affinity_enabled = each.value.session_affinity_enabled

  # Load Balancing Block
  # Description: Specifies the load balancing configuration for the origin group.
  dynamic "load_balancing" {
    for_each = each.value.load_balancing != null ? [each.value.load_balancing] : []
    content {
      additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
      sample_size                        = each.value.load_balancing.sample_size
      successful_samples_required        = each.value.load_balancing.successful_samples_required
    }
  }

  # Health Probe Block
  # Description: Specifies the health probe configuration for the origin group.
  dynamic "health_probe" {
    for_each = each.value.health_probe != null ? [each.value.health_probe] : []
    content {
      interval_in_seconds = each.value.health_probe.interval_in_seconds
      path                = each.value.health_probe.path
      protocol            = each.value.health_probe.protocol
      request_type        = each.value.health_probe.request_type
    }
  }

  # Attribute: restore_traffic_time_to_healed_or_new_endpoint_in_minutes
  # Description: Time in minutes to restore traffic to a healed or new endpoint.
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes
}

# Resource: azurerm_cdn_frontdoor_origin
# Description: Manages a frontdoor origin within a frontdoor origin group.
# 
# Arguments:
#   - for_each (object): A mapping of unique keys to objects that represents the frontdoor origins.
#   - name (string): The name of the frontdoor origin.
#   - cdn_frontdoor_origin_group_id (string): The ID of the frontdoor origin group to associate the origin with.
#   - host_name (string): The hostname or IP address of the origin.
#   - certificate_name_check_enabled (bool): Indicates whether to enable certificate name checking during SSL/TLS negotiation.
#   - enabled (bool): Indicates whether the origin is enabled for the origin group.
#   - http_port (string): The HTTP port used to communicate with the origin. Defaults to "80" if not specified.
#   - https_port (string): The HTTPS port used to communicate with the origin. Defaults to "443" if not specified.
#   - origin_host_header (string): The host header to send to the origin.
#   - priority (number): The priority of the origin in the origin group. Lower values indicate higher priority.
#   - weight (number): The weight of the origin in the origin group for load balancing. Higher values receive more traffic.

resource "azurerm_cdn_frontdoor_origin" "front_door_origin" {
  for_each                       = { for index, value in local.azurerm_cdn_frontdoor_origins : index => value }
  name                           = "${local.front_door_origin}-${each.key}"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.front_door_origin_group[each.value.parent_group_index].id
  host_name                      = each.value.child_origin.host_name
  certificate_name_check_enabled = each.value.child_origin.certificate_name_check_enabled
  enabled                        = each.value.child_origin.enabled
  http_port                      = each.value.child_origin.http_port
  https_port                     = each.value.child_origin.https_port
  origin_host_header             = each.value.child_origin.origin_host_header
  priority                       = each.value.child_origin.priority
  weight                         = each.value.child_origin.weight

  #private_link {
  #
  #}

}


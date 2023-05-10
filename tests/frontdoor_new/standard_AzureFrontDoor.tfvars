resource_group_location = "East US 2"
front_door_sku_name     = "Standard_AzureFrontDoor"

tags = {
  environment          = "dev"
  name_app             = "jcorremo"
  business_domain      = "n/a"
  service_domain       = "n/a"
  business_area        = "n/a"
  organizational_units = "management"
  name_service         = "n/a"
  cost                 = "apim"
  app_code             = "n/a"
}

frontdoor_origin_groups = [{
  health_probe = {
    interval_in_seconds = 240
    path                = "/healthProbe"
    protocol            = "Https"
    request_type        = "HEAD"
  }
  load_balancing = {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
  session_affinity_enabled                                  = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
  azurerm_cdn_frontdoor_origins = [{
    host_name                      = "jcorremo.com"
    certificate_name_check_enabled = false
    }]
}]

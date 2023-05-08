tags = {
  environment          = "dev"
  name_app             = "testjcorremo"
  business_domain      = "n/a"
  service_domain       = "n/a"
  business_area        = "n/a"
  organizational_units = "management"
  name_service         = "n/a"
  cost                 = "apim"
  app_code             = "n/a"
}


backend_pool_health_probe = [
  {
    name                = "HealthProbefrontend"
    enabled             = "true"
    path                = "/"
    protocol            = "Https"
    probe_method        = "HEAD"
    interval_in_seconds = 60
  },
  {
    name                = "HealthProbeSettingbackendappservices"
    enabled             = "true"
    path                = "/status-0123456789abcdef"
    protocol            = "Https"
    probe_method        = "GET"
    interval_in_seconds = 30
  },
]

#---------------------------------------------------------
# Backend pool load balancing frontdoor Creation 
#---------------------------------------------------------
backend_pool_load_balancing = [
  {
    name                            = "LoadBalancingSettings"
    sample_size                     = 4
    successful_samples_required     = 2
    additional_latency_milliseconds = 0
  },
]

name_routing_rule = {
  name_routing_website             = "routingwebsite"
  name_routing_redirecthttptohttps = "redirecthttptohttps"
}

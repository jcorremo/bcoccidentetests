# Create a frontdoor
resource "azurerm_frontdoor" "fd" {
	name											= var.name
	resource_group_name								= var.resource_group_name
	enforce_backend_pools_certificate_name_check	= var.enforce_backend_pools_certificate_name_check
	backend_pools_send_receive_timeout_seconds		= var.backend_pools_send_receive_timeout_seconds
	tags	= {
		environment				= var.tag_environment
		app						= var.tag_name_app
		organizational_units	= var.tag_organizational_units
		business_area			= var.tag_business_area
		business_domain			= var.tag_business_domain
		service_domains			= var.tag_service_domain
		cost					= var.tag_cost
		name_service			= var.tag_name_service
		}
dynamic "routing_rule" {
	for_each = var.enable_default_routing_rule ? ["fake"] : []
	content {
		name               = join("-", [local.backend_pools[0].name, "rr"])
		accepted_protocols = ["Https"]
		patterns_to_match  = ["/*"]
		frontend_endpoints = ["${var.name}-azurefd-net"]
		enabled            = true    
			forwarding_configuration {
			forwarding_protocol                   = "HttpsOnly"
			backend_pool_name                     = local.backend_pools[0].name
			cache_enabled                         = false
			cache_use_dynamic_compression         = false
			cache_query_parameter_strip_directive = "StripAll"
			}
    }
  }
dynamic "backend_pool_load_balancing" {
	for_each = local.backend_pool_load_balancings
	content {
		name							= "LoadBalancingSettings"
		sample_size						= lookup(backend_pool_load_balancing.value, "sample_size", 4)
		successful_samples_required		= lookup(backend_pool_load_balancing.value, "successful_samples_required", 2)
		additional_latency_milliseconds	= lookup(backend_pool_load_balancing.value, "additional_latency_milliseconds", 0)
    }
  }	

 dynamic "backend_pool_health_probe" {
    for_each = local.backend_pool_health_probes
    content {
      name = "HealthProbeSettingfrontend"
      enabled             = lookup(backend_pool_health_probe.value, "enabled", true)
      path                = lookup(backend_pool_health_probe.value, "path", "/")
      protocol            = lookup(backend_pool_health_probe.value, "protocol", "Https")
      probe_method        = lookup(backend_pool_health_probe.value, "probe_method", "HEAD")
      interval_in_seconds = lookup(backend_pool_health_probe.value, "interval_in_seconds", 60)
    }
  }
		
dynamic "backend_pool" {
    for_each = local.backend_pools
    content {
      name = lookup(backend_pool.value, "name")
      load_balancing_name = "LoadBalancingSettings"
      health_probe_name = "HealthProbeSettingfrontend"

dynamic "backend" {
        for_each = lookup(backend_pool.value, "backends")
        # To Change
        # for_each = var.backend_pool_backends
        content {
          enabled     = lookup(backend.value, "enabled", true)
          address     = lookup(backend.value, "address")
          host_header = lookup(backend.value, "host_header")
          http_port   = lookup(backend.value, "http_port", 80)
          https_port  = lookup(backend.value, "https_port", 443)
          priority    = lookup(backend.value, "priority", null)
          weight      = lookup(backend.value, "weight", null)
        }
      }
    }
  }		
dynamic "frontend_endpoint" {
    for_each = var.enable_default_frontend_endpoint ? ["fake"] : []
    content {
		name										= "${var.name}-azurefd-net"
		host_name									= "${var.name}.azurefd.net"
		session_affinity_enabled					= false
		session_affinity_ttl_seconds				= 0
		custom_https_provisioning_enabled			= false
		web_application_firewall_policy_link_id		= var.web_application_firewall_policy_link_id
		custom_https_configuration {
			certificate_source					= "FrontDoor"
			}
    }
  }
}
#---------------------------------------------------------
# Frontdoor Creation 
#----------------------------------------------------------
resource "azurerm_frontdoor" "frontdoor" {
  name                = "${var.tags.name_app}-fd-${var.tags.environment}"
  resource_group_name = var.resource_group_name
  # enforce_backend_pools_certificate_name_check = var.enforce_backend_pools_certificate_name_check

  dynamic "backend_pool" {
    for_each = var.backend_pool == null ? [] : var.backend_pool
    content {
      name                = backend_pool.value.name
      load_balancing_name = backend_pool.value.load_balancing_name
      health_probe_name   = backend_pool.value.health_probe_name

      dynamic "backend" {
        for_each = backend_pool.value.backend == null ? [] : backend_pool.value.backend
        content {
          address     = backend.value.address
          host_header = backend.value.host_header
          http_port   = backend.value.http_port
          https_port  = backend.value.https_port
        }
      }
    }
  }

  dynamic "backend_pool_health_probe" {
    for_each = var.backend_pool_health_probe == null ? [] : var.backend_pool_health_probe
    content {
      name                = replace(backend_pool_health_probe.value.name, "-", "")
      enabled             = lookup(backend_pool_health_probe.value, "enabled", true)
      path                = lookup(backend_pool_health_probe.value, "path", "/")
      protocol            = lookup(backend_pool_health_probe.value, "protocol", "Https")
      probe_method        = lookup(backend_pool_health_probe.value, "probe_method", "HEAD")
      interval_in_seconds = lookup(backend_pool_health_probe.value, "interval_in_seconds", 60)
    }
  }

  dynamic "backend_pool_load_balancing" {
    for_each = var.backend_pool_load_balancing == null ? [] : var.backend_pool_load_balancing
    content {
      name                            = replace(backend_pool_load_balancing.value.name, "-", "")
      sample_size                     = lookup(backend_pool_load_balancing.value, "sample_size", 4)
      successful_samples_required     = lookup(backend_pool_load_balancing.value, "successful_samples_required", 2)
      additional_latency_milliseconds = lookup(backend_pool_load_balancing.value, "additional_latency_milliseconds", 0)
    }
  }

  dynamic "frontend_endpoint" {
    for_each = var.frontend_endpoint == null ? [] : tolist([var.frontend_endpoint])
    content {
      name                                    = replace(frontend_endpoint.value.name, "-", "")
      host_name                               = "${var.tags.name_app}-fd-${var.tags.environment}.azurefd.net"
      web_application_firewall_policy_link_id = frontend_endpoint.value.web_application_firewall_policy_link_id
    }
  }

  dynamic "routing_rule" {
    for_each = var.routing_rule == null ? [] : var.routing_rule
    content {
      name               = replace(routing_rule.value.name, "-", "")
      frontend_endpoints = routing_rule.value.frontend_endpoints
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.patterns_to_match
      dynamic "forwarding_configuration" {
        for_each = routing_rule.value.forwarding_configuration == null ? [] : tolist([routing_rule.value.forwarding_configuration])
        content {
          backend_pool_name   = forwarding_configuration.value.backend_pool_name
          forwarding_protocol = forwarding_configuration.value.forwarding_protocol
        }
      }
      dynamic "redirect_configuration" {
        for_each = routing_rule.value.redirect_configuration == null ? [] : tolist([routing_rule.value.redirect_configuration])
        content {
          redirect_protocol = redirect_configuration.value.redirect_protocol
          redirect_type     = redirect_configuration.value.redirect_type
        }
      }
    }
  }
  tags = {
    environment          = var.tags.environment
    name_app             = var.tags.name_app
    business_domain      = var.tags.business_domain
    service_domain       = var.tags.service_domain
    business_area        = var.tags.business_area
    organizational_units = var.tags.organizational_units
    name_service         = "frontdoor"
    cost                 = var.tags.cost
  }
}

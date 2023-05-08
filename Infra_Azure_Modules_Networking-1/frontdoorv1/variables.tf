variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Front Door service. Must be globally unique. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created."
}

variable "backend_pool" {
  type = list(object({
    name = string # (Required) Specifies the name of the Backend Pool.
    backend = list(object({
      enabled     = optional(bool)   # (Optional) Specifies if the backend is enabled or not. Valid options are true or false. Defaults to true.
      address     = string           # (Required) Location of the backend (IP address or FQDN)
      host_header = string           # (Required) The value to use as the host header sent to the backend.
      http_port   = number           # (Required) The HTTP TCP port number. Possible values are between 1 - 65535.
      https_port  = number           # (Required) The HTTPS TCP port number. Possible values are between 1 - 65535.
      priority    = optional(number) # (Optional) Priority to use for load balancing. Higher priorities will not be used for load balancing if any lower priority backend is healthy. Defaults to 1.
      weight      = optional(number) # (Optional) Weight of this endpoint for load balancing purposes. Defaults to 50.
    }))                               # (Required) A backend block as defined below.
    load_balancing_name = string     # (Required) Specifies the name of the backend_pool_load_balancing block within this resource to use for this Backend Pool.
    health_probe_name   = string     # (Required) Specifies the name of the backend_pool_health_probe block within this resource to use for this Backend Pool.
  }))
  description = "(Required) A backend_pool block as defined below."
}

variable "backend_pool_health_probe" {
  type = list(object({
    name                = string           # (Required) Specifies the name of the Health Probe.
    enabled             = optional(bool)   # (Optional) Is this health probe enabled? Dafaults to true.
    path                = optional(string) # (Optional) The path to use for the Health Probe. Default is /.
    protocol            = optional(string) # (Optional) Protocol scheme to use for the Health Probe. Defaults to Http.
    probe_method        = optional(string) # (Optional) Specifies HTTP method the health probe uses when querying the backend pool instances. Possible values include: Get and Head. Defaults to Get.
    interval_in_seconds = optional(number) # (Optional) The number of seconds between each Health Probe. Defaults to 120.
  }))
  description = "(Required) A backend_pool_health_probe block as defined below."
}

variable "backend_pool_load_balancing" {
  type = list(object({
    name                            = string           # (Required) Specifies the name of the Load Balancer.
    sample_size                     = optional(number) # (Optional) The number of samples to consider for load balancing decisions. Defaults to 4.
    successful_samples_required     = optional(number) # (Optional) The number of samples within the sample period that must succeed. Defaults to 2.
    additional_latency_milliseconds = optional(number) # (Optional) The additional latency in milliseconds for probes to fall into the lowest latency bucket. Defaults to 0.
  }))
  description = "(Required) A backend_pool_load_balancing block as defined below."
}

variable "backend_pools_send_receive_timeout_seconds" {
  type        = number
  description = "(Optional) Specifies the send and receive timeout on forwarding request to the backend. When the timeout is reached, the request fails and returns. Possible values are between 0 - 240. Defaults to 60."
  default     = 60
}

variable "enforce_backend_pools_certificate_name_check" {
  type        = bool
  description = "(Required) Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests. Permitted values are true or false."
  default     = true
}

variable "load_balancer_enabled" {
  type        = bool
  description = "(Optional) Should the Front Door Load Balancer be Enabled? Defaults to true."
  default     = true
}

variable "friendly_name" {
  type        = string
  description = "(Optional) A friendly name for the Front Door service."
  default     = null
}

variable "frontend_endpoint" {
  type = object({
    name                                    = string           # (Required) Specifies the name of the frontend_endpoint.
    host_name                               = string           # (Required) Specifies the host name of the frontend_endpoint. Must be a domain name. In order to use a name.azurefd.net domain, the name value must match the Front Door name.
    session_affinity_enabled                = optional(bool)   # (Optional) Whether to allow session affinity on this host. Valid options are true or false Defaults to false.
    session_affinity_ttl_seconds            = optional(number) # (Optional) The TTL to use in seconds for session affinity, if applicable. Defaults to 0.
    web_application_firewall_policy_link_id = optional(string) # (Optional) Defines the Web Application Firewall policy ID for each host.
  })
  description = "(Required) A frontend_endpoint block as defined below."
}
variable "routing_rule" {
	type = list(object({
    name               = string         # (Required) Specifies the name of the Routing Rule.
    frontend_endpoints = list(string)   # (Required) The names of the frontend_endpoint blocks within this resource to associate with this routing_rule.
    accepted_protocols = list(string)   # (Optional) Protocol schemes to match for the Backend Routing Rule. Defaults to Http.
    patterns_to_match  = list(string)   # (Optional) The route patterns for the Backend Routing Rule. Defaults to /*.
    enabled            = optional(bool) # (Optional) Enable or Disable use of this Backend Routing Rule. Permitted values are true or false. Defaults to true.
    forwarding_configuration = optional(object({
      backend_pool_name                     = string           # (Required) Specifies the name of the Backend Pool to forward the incoming traffic to.
      cache_enabled                         = optional(bool)   # (Optional) Specifies whether to Enable caching or not. Valid options are true or false. Defaults to false.
      cache_use_dynamic_compression         = optional(bool)   # (Optional) Whether to use dynamic compression when caching. Valid options are true or false. Defaults to false.
      cache_query_parameter_strip_directive = optional(string) # (Optional) Defines cache behaviour in relation to query string parameters. Valid options are StripAll or StripNone. Defaults to StripAll.
      custom_forwarding_path                = optional(string) # (Optional) Path to use when constructing the request to forward to the backend. This functions as a URL Rewrite. Default behaviour preserves the URL path.
      forwarding_protocol                   = optional(string) # (Optional) Protocol to use when redirecting. Valid options are HttpOnly, HttpsOnly, or MatchRequest. Defaults to HttpsOnly.
    }))                                                        # (Optional) A forwarding_configuration block as defined below.
    redirect_configuration = optional(object({
      custom_host         = optional(string)	# (Optional) Set this to change the URL for the redirection.
      redirect_protocol   = optional(string)	# (Optional) Protocol to use when redirecting. Valid options are HttpOnly, HttpsOnly, or MatchRequest. Defaults to MatchRequest
      redirect_type       = string			# (Required) Status code for the redirect. Valida options are Moved, Found, TemporaryRedirect, PermanentRedirect.
      custom_fragment     = optional(string)       # (Optional) The destination fragment in the portion of URL after '#'. Set this to add a fragment to the redirect URL.
      custom_path         = optional(string)       # (Optional) The path to retain as per the incoming request, or update in the URL for the redirection.
      custom_query_string = optional(string)       # (Optional) Replace any existing query string from the incoming request URL.
    }))                                            # (Optional) A redirect_configuration block as defined below.
  }))
  description = "(Required) A routing_rule block as defined below."
}
variable "tags" {
  type = object({
    environment          = string # (Required) tipo de ambiente
    name_app             = string # (Required) nombre de la aplicacion
    business_domain      = string # (Required) proceso de negocio al cual esta asociada la aplicacion
    service_domain       = string # (Required) proceso de negocio al cual esta asociada la aplicacion
    business_area        = string # (Required) area de negocio a la cual pertenece la aplicacion
    organizational_units = string # (Required) unidad organizacional a la cual pertenece la  aplicacion
    name_service         = string # (Required) nombre del tipo de servicio desplegado
    cost                 = string # (Required) aplicacion asociado a su control de costos
  })
  description = "(Required) Tags to apply to all resources created."
  sensitive   = false
}
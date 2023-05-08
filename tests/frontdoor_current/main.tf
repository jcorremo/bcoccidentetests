resource "azurerm_resource_group" "rg_main" {
  location = var.resource_group_location
  name     = var.tags.name_app
}

module "frontdoor" {
  source = "../../Infra_Azure_Modules_Networking-1/frontdoorv1"
  providers = {
    azurerm = azurerm
  }

  ##ADDS
  name = "test"

  frontend_endpoint = {
    name      = "exampleFrontendEndpoint1"
    host_name = "example-FrontDoor.azurefd.net"
  }

  backend_pool = [
    {
      name = "exampleBackendBing"
      backend = [
        {
          host_header = "www.bing.com"
          address     = "www.bing.com"
          http_port   = 80
          https_port  = 443
        },
      ]
      load_balancing_name = "LoadBalancingSettings"
      health_probe_name   = "HealthProbeSettingbackendappservices"
    },
  ]


  routing_rule = [
    {
      name               = "exampleRoutingRule1"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/*"]
      frontend_endpoints = ["exampleFrontendEndpoint1"]
      forwarding_configuration = {
        forwarding_protocol = "MatchRequest"
        backend_pool_name   = "exampleBackendBing"
      }
    }
  ]


  ##END ADDS
  ##REMOVED
  #name_app            = var.tags.name_app
  location            = "Global"
  resource_group_name = azurerm_resource_group.rg_main.name
  tags                = var.tags

  backend_pool_health_probe   = var.backend_pool_health_probe
  backend_pool_load_balancing = var.backend_pool_load_balancing

}

# Create a frontdoor firewall policy
resource "azurerm_frontdoor_firewall_policy" "fdwaf" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  enabled                           = var.enable_waf
  mode                              = var.waf_mode
  redirect_url                      = "https://www.microsoft.com/es-co"
  custom_block_response_status_code = var.custom_block_response_status_code
  custom_block_response_body        = var.custom_block_response_body
  tags = {
    environment          = var.tag_environment
    name_app             = var.tag_name_app
    organizational_units = var.tag_organizational_units
    business_area        = var.tag_business_area
    business_domain      = var.tag_business_domain
    service_domains      = var.tag_service_domain
    cost                 = var.tag_cost
    name_service         = var.tag_name_service
  }
  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
  }
  dynamic "managed_rule" {
    for_each = var.managed_rule == null ? [] : tolist([var.managed_rule])
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
    }
  }
}

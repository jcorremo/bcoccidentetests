output "waf_policy_id" {
  description = "The ID of the WAF policy."
  value       = azurerm_frontdoor_firewall_policy.fdwaf.id
}
#
# Old configuration
#
#output "app_service_plan_id" {
#  description = "Id of the created App Service Plan"
#  value       = azurerm_app_service_plan.plan.id
#}
#
#output "app_service_plan_name" {
#  description = "Name of the created App Service Plan"
#  value       = azurerm_app_service_plan.plan.name
#}
#
#output "app_service_plan_location" {
#  description = "Azure location of the created App Service Plan"
#  value       = azurerm_app_service_plan.plan.location
#}
#
#output "app_service_plan_max_workers" {
#  description = "Maximum number of workers for the created App Service Plan"
#  value       = azurerm_app_service_plan.plan.maximum_number_of_workers
#}




# Output: app_service_plan_id
# Description: The ID of the app service plan.
output "app_service_plan_id" {
  description = "The ID of the app service plan."
  value       = azurerm_service_plan.azurerm_service_plan_main.id
}

# Output: app_service_plan_name
# Description: The name of the app service plan.
output "app_service_plan_name" {
  description = "The name of the app service plan."
  value       = azurerm_service_plan.azurerm_service_plan_main.name
}

# Output: app_service_plan_location
# Description: The location of the app service plan.
output "app_service_plan_location" {
  description = " The location of the app service plan."
  value       = azurerm_service_plan.azurerm_service_plan_main.location
}

# Output: app_service_plan_max_workers
# Description: The maximum number of elastic workers for the app service plan.
output "app_service_plan_max_workers" {
  description = "The maximum number of elastic workers for the app service plan."
  value       = azurerm_service_plan.azurerm_service_plan_main.maximum_elastic_worker_count
}

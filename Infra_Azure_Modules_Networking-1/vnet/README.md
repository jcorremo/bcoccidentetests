# Azure Virtual Network Terraform Module

This [Terraform] module deploys a Virtual Network in Azure with a subnet or a set of subnets passed in as input parameters.

The module does not create nor expose a security group. This would need to be defined separately as additional security rules on subnets in the deployed network.

The current version includes the following resources (`main.tf` file):

- [Azure Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| azurerm | ~> 3.29.1 |

## Providers

| Name | Version |
|------|---------|
| hashicorp/azurerm | ~> 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of virtual network | `string` | `null` | yes |
| location | Azure location for virtual network | `string` | `null` | yes |
| resource_group_name | Name of the resource group to be imported | `string` | `null` | yes |
| address_space | The address space that is used the virtual network. You can supply more than one address space. | `list(string)` | `null` | yes |
| tags | The tags to associate with your resource group | <pre> object({<br> environment = string # (Required) tipo de ambiente e.g. "prod","dev","qa"<br> name_app = string # (Required) nombre de la aplicacion<br> business_domain = string # (Required) proceso de negocio al cual esta asociada la aplicacion<br> service_domain = string # (Required) proceso de negocio al cual esta asociada la aplicacion<br> business_area = string # (Required) area de negocio a la cual pertenece la aplicacion e.g. "critical_mision", "business_support", "analytical_mngmt", "shared_services", "sales&services","n/a" }))<br> cost = string # (Required) aplicacion asociado a su control de costos<br> app_code = string # (Required) codigo de la aplicacion <br> })</pre> | `{}` | yes |
| subnet_list_obj | block as defined below for subnet creation | <pre> subnet_list_obj = [{<br> name = var.subnet_list_obj[count.index].name # (Required) The name of the subnet. Changing this forces a new resource to be created.<br> resource_group_name = var.resource_group_name # (Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created.<br> virtual_network_name = azurerm_virtual_network.vnet.name # (Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.<br> address_prefixes = var.subnet_list_obj[count.index].address_prefixes # (Required) The address prefixes to use for the subnet.<br> service_endpoints = var.subnet_list_obj[count.index].service_endpoints # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web.<br> private_endpoint_network_policies_enabled = var.subnet_list_obj[count.index].private_endpoint_network_policies_enabled # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.<br> private_link_service_network_policies_enabled = var.subnet_list_obj[count.index].private_link_service_network_policies_enabled # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.<br> dynamic "delegation" { # block supports the following:<br> name = delegation.value.name # (Required) A name for this delegation.<br> service_delegation { # (Required) A service_delegation block as defined below.<br> name                                 =  delegation.value.service_delegation_name # (Required) The name of service to delegate to. Possible values include Microsoft.ApiManagement/service, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.Logic/integrationServiceEnvironments, Microsoft.LabServices/labplans,Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/managedResolvers, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments and PaloAltoNetworks.Cloudngfw/firewalls.<br> actions                              =  delegation.value.service_delegation_actions # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include Microsoft.Network/publicIPAddresses/read,Microsoft.Network/virtualNetworks/read,Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.}))</pre> | `null` | no |

## Module Usage:
```terraform
# Por defecto, el modulo no crea el grupo de recursos
# Para eso antes del llamar el modulo de RG 
# Se debe previamente crear el grupo de recursos o llamar el grupo de recursos ya existente

module "rg" {
	source = "git::git@github.com:bocc-principal/Infra_Azure_Modules_Managemt_Governan.git//resource_group?ref=v1.0.0"
		name_app		= var.tags.name_app
		tags			= var.tags
		lock_level		= "CanNotDelete"
}
module "vnet_azure" {
	source = "git::git@github.com:bocc-principal/Infra_Azure_Modules_Networking.git//vnet?ref=v1.0.0"
		name											= "${var.namevnet}-${var.name_business_domain}-${var.tags.name_app}-${var.tags.environment}"
		location										= azurerm_resource_group.rg.location
		resource_group_name								= azurerm_resource_group.rg.name
		address_space									= var.address_space
		tags											= var.tags
		subnet_list_obj = [
			{
			name										= var.subnet1.name
			address_prefixes							= var.subnet1.address_prefixes
			private_endpoint_network_policies_enabled	= var.subnet1.private_endpoint_network_policies_enabled
			},
			{
			name										= var.subnet2.name
			address_prefixes							= var.subnet2.address_prefixes
			},
			{
			name										= var.subnet3.name
			address_prefixes							= var.subnet3.address_prefixes
			delegation									= [
				{
				name									= var.subnet3.delegation_name
				service_delegation_name					= var.subnet3.service_delegation_name
				},]
			},
		]		
}
```
## Outputs

| Name | Description | type |
|------|-------------|------|
| virtual_network_id | Id of the virtual network created | `string` |
| virtual_network_location | location of the virtual network created | `string` |
| virtual_network_name | name of the virtual network created | `string` |
| virtual_network_space | network space of the virtual network created| `string` |
#---------------------------------------------------------
# vnet creation 
#----------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
	name					          = var.name
	location 				        = var.location
	resource_group_name		  = var.resource_group_name
	address_space			      = var.address_space
  tags = {
		bdo_environment           = var.tags.environment
		bdo_name_app              = var.tags.name_app
		bdo_business_domain       = var.tags.business_domain
		bdo_service_domain        = var.tags.service_domain
		bdo_business_area         = var.tags.business_area
		bdo_organizational_units  = var.tags.organizational_units
		bdo_name_service          = "virtual_network"
		bdo_cost                  = var.tags.cost
		bdo_app_code              = var.tags.app_code
		}
}
#---------------------------------------------------------
# subnet creation 
#----------------------------------------------------------
resource "azurerm_subnet" "subnet_vnet" {
  count                                           = length(var.subnet_list_obj)
  name                                            = var.subnet_list_obj[count.index].name # (Required) The name of the subnet. Changing this forces a new resource to be created.
  resource_group_name                             = var.resource_group_name # (Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created.
  virtual_network_name                            = azurerm_virtual_network.vnet.name # (Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.
  address_prefixes                                = var.subnet_list_obj[count.index].address_prefixes # (Required) The address prefixes to use for the subnet.
  service_endpoints                               = var.subnet_list_obj[count.index].service_endpoints # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web.
  private_endpoint_network_policies_enabled       = var.subnet_list_obj[count.index].private_endpoint_network_policies_enabled # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.
  private_link_service_network_policies_enabled   = var.subnet_list_obj[count.index].private_link_service_network_policies_enabled # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.
  dynamic "delegation" { # block supports the following:
    for_each = var.subnet_list_obj[count.index].delegation == null ? [] : var.subnet_list_obj[count.index].delegation
      content {
        name    = delegation.value.name # (Required) A name for this delegation.
          service_delegation { # (Required) A service_delegation block as defined below.
            name                                 =  delegation.value.service_delegation_name # (Required) The name of service to delegate to. Possible values include Microsoft.ApiManagement/service, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.Logic/integrationServiceEnvironments, Microsoft.LabServices/labplans,Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/managedResolvers, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments and PaloAltoNetworks.Cloudngfw/firewalls.
			      actions                              =  delegation.value.service_delegation_actions # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include Microsoft.Network/publicIPAddresses/read,Microsoft.Network/virtualNetworks/read,Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
                }
		      }            
	    }
	}
#Azure CLI config (azure cli installed prerequisite)
export TENANT_ID="nttdataco.onmicrosoft.com"
### Login via azure cli
az login --tenant $TENANT_ID
### Create SP to deployments appId of SP and PSSWD
az ad sp create-for-rbac -n deployment-mger_sp >> ./secrets_sp

SP_RESPONSE=$(cat ./secrets_sp)
ARM_CLIENT_ID=$(echo $SP_RESPONSE | jq -r '.appId')
ARM_CLIENT_SECRET=$(echo $SP_RESPONSE | jq -r '.password')
### Assign permissions to SP
export IAC_SUBSCRIPTION_ID="0bea0a37-89cb-43fb-976f-0d8a3d8b1e4b"
az role assignment create --assignee $ARM_CLIENT_ID --role "Contributor" --scope "/subscriptions/$IAC_SUBSCRIPTION_ID"
az role assignment create --assignee $ARM_CLIENT_ID --role "Contributor" --scope "/providers/Microsoft.Authorization/roleDefinitions"

az account set --subscription $IAC_SUBSCRIPTION_ID

RESOURCE_GROUP_NAME=TFSTATE
STORAGE_ACCOUNT_NAME=iacgralstatepocdeployer
CONTAINER_NAME=iacgralstate

### Create resource group
az group create --name $RESOURCE_GROUP_NAME --location 	centralus
### Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
### Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

#Create TF files definition
###Export config variables
export ARM_CLIENT_ID="$ARM_CLIENT_ID"
export ARM_CLIENT_SECRET="$ARM_CLIENT_SECRET"
export ARM_SUBSCRIPTION_ID="$IAC_SUBSCRIPTION_ID"
export ARM_TENANT_ID="$TENANT_ID"
###Create IaC.
###Init components
terraform init
###check deploy
terraform plan
###deploy
terraform apply

#Create the github token to deployment center

 terraform destroy --target module.base-infra.azurerm_cosmosdb_sql_container.deploy_manager_cosmosdb_container
 terraform destroy --target module.base-infra.azurerm_cosmosdb_sql_database.deploy_manager_cosmosdb_db
 terraform destroy --target module.base-infra.azurerm_cosmosdb_account.deploy_manager_cosmosdb
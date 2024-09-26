// Set the target scope to subscription level
targetScope = 'subscription'

@sys.description('Project name prefix to be added to all resource names.')
param parProjectPrefix string

@sys.description('Environment name prefix to be added to resource groups.')
param parEnvironmentPrefix string

@sys.description('The Azure Region to deploy the resource group into.')
param parLocation string

@sys.description('Tags to apply to the resource group.')
param parTags object

// Create the resource group at the subscription scope
resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${parProjectPrefix}-${parEnvironmentPrefix}-rg-spoke-vnet'
  location: parLocation
  tags: parTags
}

// Output resource group name and ID
output resourceGroupName string = resResourceGroup.name
output resourceGroupId string = resResourceGroup.id

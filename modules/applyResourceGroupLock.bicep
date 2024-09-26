// modules/resourceGroupLock.bicep

@description('Project name prefix to be added to the lock name.')
param parProjectPrefix string

@description('Project name prefix to be added to the lock name.')
param parEnvironmentPrefix string

@description('Resource lock configuration for the resource group.')
param parResourceGroupLock object

// Apply the lock to the resource group
resource resResourceGroupLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: '${parProjectPrefix}-${parEnvironmentPrefix}-rg-spoke-vnet'
  properties: {
    level: parResourceGroupLock.kind
    notes: parResourceGroupLock.notes
  }
}

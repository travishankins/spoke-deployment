// modules/resourceGroupLock.bicep

@description('Project name prefix to be added to the lock name.')
param parProjectPrefix string

@description('Resource lock configuration for the resource group.')
param parResourceGroupLock object

// Apply the lock to the resource group
resource resResourceGroupLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: '${parProjectPrefix}-rg-networking-lock'
  properties: {
    level: parResourceGroupLock.kind
    notes: parResourceGroupLock.notes
  }
}

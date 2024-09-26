// Set the target scope to subscription level
targetScope = 'subscription'

@sys.description('Project name prefix to be added to all resource names.')
param parProjectPrefix string

@sys.description('Environment name prefix to be added to all virtual networks.')
param parEnvironmentPrefix string

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string

@sys.description('Tags to apply to all resources in this module.')
param parTags object

@sys.description('CIDR for spoke network.')
param parSpokeNetworkAddressPrefix string


@sys.description('CIDR for spoke subnet.')
param paraddressPrefix string

@sys.description('Resource lock configuration for the resource group.')
param parResourceGroupLock object = {
  kind: 'CanNotDelete'
  notes: 'This lock ensures the resource group cannot be deleted.'
}

@sys.description('The principal ID of the user or group to be assigned the [QRM] Subscription Owner role.')
param parSubscriptionOwnerPrincipalId string

@sys.description('The principal ID of the user or group to be assigned the [QRM] App Owner role.')
param parAppOwnerPrincipalId string

@sys.description('The role definition ID for [QRM] Subscription Owner.')
param parSubscriptionOwnerRoleId string

@sys.description('The role definition ID for [QRM] App Owner.')
param parAppOwnerRoleId string

@sys.description('The name of the resource group where the resources will be deployed.')
param parResourceGroupName string

// Deploy the networking resources into the existing resource group
module networkingModule 'modules/deployInfrastructure.bicep' = {
  name: 'networkingDeployment'
  scope: resourceGroup(parResourceGroupName)  // Set the scope to the existing resource group
  params: {
    parProjectPrefix: parProjectPrefix
    parEnvironmentPrefix: parEnvironmentPrefix
    parLocation: parLocation
    parTags: parTags
    parSpokeNetworkAddressPrefix: parSpokeNetworkAddressPrefix
    paraddressPrefix: paraddressPrefix
    parSpokeNetworkName: 'vnet-spoke-ncus'
    parDnsServerIps: [
      '172.24.3.5','172.24.3.4'
    ]
    parNextHopIpAddress: '10.120.0.9'
  }
}

// Call the module to apply the resource group lock using the existing resource group
module applyResourceGroupLock 'modules/applyResourceGroupLock.bicep' = {
  name: 'resourceGroupLockDeployment'
  scope: resourceGroup(parResourceGroupName)  // Set the scope to the existing resource group
  params: {
    parProjectPrefix: parProjectPrefix
    parResourceGroupLock: parResourceGroupLock
    parEnvironmentPrefix: parEnvironmentPrefix
  }
}

// Deploy the role assignments at the subscription level after networking resources are deployed
module roleAssignments 'modules/assignRoles.bicep' = {
  name: 'assignRoles'
  scope: subscription()
  params: {
    parSubscriptionOwnerPrincipalId: parSubscriptionOwnerPrincipalId
    parAppOwnerPrincipalId: parAppOwnerPrincipalId
    parSubscriptionOwnerRoleId: parSubscriptionOwnerRoleId
    parAppOwnerRoleId: parAppOwnerRoleId
  }
  dependsOn: [
    networkingModule  // Ensure that role assignments happen after the networking resources are deployed
  ]
}

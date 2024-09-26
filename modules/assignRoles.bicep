// ===============================================================
// Role Assignment Bicep Module
// This module is used to assign roles at the subscription level for the [QRM] Subscription Owner
// and [QRM] App Owner roles. It uses the principal ID (user, group, or service principal)
// and the role definition ID for each role.
// ===============================================================

// Specify that the target scope for this module is at the subscription level
targetScope = 'subscription'

// ---------------------------------------------------------------
// Parameter Definitions
// ---------------------------------------------------------------

// The principal ID of the user, group, or service principal to be assigned the [QRM] Subscription Owner role.
@description('The principal ID of the user or group to be assigned the [QRM] Subscription Owner role.')
param parSubscriptionOwnerPrincipalId string

// The principal ID of the user, group, or service principal to be assigned the [QRM] App Owner role.
@description('The principal ID of the user or group to be assigned the [QRM] App Owner role.')
param parAppOwnerPrincipalId string

// The role definition ID for the [QRM] Subscription Owner role (this should be the role's GUID).
@description('The role definition ID for [QRM] Subscription Owner.')
param parSubscriptionOwnerRoleId string

// The role definition ID for the [QRM] App Owner role (this should be the role's GUID).
@description('The role definition ID for [QRM] App Owner.')
param parAppOwnerRoleId string

// ---------------------------------------------------------------
// Resource Definitions
// ---------------------------------------------------------------

// ----- Role Assignment: [QRM] Subscription Owner -----
// This resource assigns the [QRM] Subscription Owner role to the specified principal ID at the subscription level.
resource subscriptionOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  // Generate a unique name for the role assignment using a GUID based on the principal ID, role definition ID, and subscription ID
  name: guid(parSubscriptionOwnerPrincipalId, parSubscriptionOwnerRoleId, subscription().id)

  // Set the scope to the subscription level, meaning the role will be assigned for the entire subscription
  scope: subscription()

  properties: {
    // The principal (user, group, or service principal) being assigned the role
    principalId: parSubscriptionOwnerPrincipalId

    // The role definition ID (i.e., the GUID of the [QRM] Subscription Owner role)
    roleDefinitionId: parSubscriptionOwnerRoleId

    // Define the type of the principal, such as 'User', 'Group', or 'ServicePrincipal'
    principalType: 'User' // Adjust as necessary ('User', 'Group', or 'ServicePrincipal')
  }
}

// ----- Role Assignment: [QRM] App Owner -----
// This resource assigns the [QRM] App Owner role to the specified principal ID at the subscription level.
resource appOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  // Generate a unique name for the role assignment using a GUID based on the principal ID, role definition ID, and subscription ID
  name: guid(parAppOwnerPrincipalId, parAppOwnerRoleId, subscription().id)

  // Set the scope to the subscription level, meaning the role will be assigned for the entire subscription
  scope: subscription()

  properties: {
    // The principal (user, group, or service principal) being assigned the role
    principalId: parAppOwnerPrincipalId

    // The role definition ID (i.e., the GUID of the [QRM] App Owner role)
    roleDefinitionId: parAppOwnerRoleId

    // Define the type of the principal, such as 'User', 'Group', or 'ServicePrincipal'
    principalType: 'User' // Adjust as necessary ('User', 'Group', or 'ServicePrincipal')
  }
}

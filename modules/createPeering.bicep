@description('The resource ID of the existing hub virtual network.')
param vnetHubId string

@description('The resource ID of the existing spoke one virtual network.')
param vnetSpokeOneId string

resource peerToSpokeOne 'Microsoft.Network/virtualNetworkPeerings@2022-01-01' = {
  name: 'peer-to-spoke'
  properties: {
    allowForwardedTraffic: false
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetSpokeOneId
    }
  }
}

resource peerFromSpokeOneToHub 'Microsoft.Network/virtualNetworkPeerings@2022-01-01' = {
  name: 'peer-from-spoke-to-hub'
  properties: {
    allowForwardedTraffic: false
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetHubId
    }
  }
}

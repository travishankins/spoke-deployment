// modules/deployInfrastructure.bicep

@description('Project name prefix to be added to all resource names.')
param parProjectPrefix string

@description('The Azure Region to deploy the resources into.')
param parLocation string

@description('Tags to apply to all resources in this module.')
param parTags object

@description('Spoke network address prefix.')
param parSpokeNetworkAddressPrefix string

@description('DNS Server IP addresses for the VNet.')
param parDnsServerIps array

@description('Next hop IP address.')
param parNextHopIpAddress string

@description('Resource ID of the Hub Virtual Network.')
param hubVNetId string

// ----- Existing Hub VNet Reference -----
resource existingHubVNet 'Microsoft.Network/virtualNetworks@2023-02-01' existing = {
  id: hubVNetId  // Correctly referencing the Hub VNet by its full Resource ID
}

// ----- Spoke Virtual Network -----
resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: '${parProjectPrefix}-prd-vnet-spoke-ncus' // Hardcoded Spoke VNet name
  location: parLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        parSpokeNetworkAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: parDnsServerIps
    }
  }
}

// ----- Route Table -----
resource resSpokeToHubRouteTable 'Microsoft.Network/routeTables@2023-02-01' = {
  name: '${parProjectPrefix}-rtb-ncus'
  location: parLocation
  tags: parTags
  properties: {
    routes: [
      {
        name: '${parProjectPrefix}-udr-ncus'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parNextHopIpAddress
        }
      }
    ]
  }
}

// ----- Subnet with Route Table Association -----
resource resSpokeSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  parent: resSpokeVirtualNetwork
  name: '${parProjectPrefix}-prd-snet-ncus-01'
  properties: {
    addressPrefix: '10.11.1.0/24'
    routeTable: !empty(parNextHopIpAddress) ? {
      id: resSpokeToHubRouteTable.id
    } : null
  }
}

// ----- VNet Peering: Spoke to Hub -----
resource resSpokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-02-01' = {
  name: '${resSpokeVirtualNetwork.name}-to-${existingHubVNet.name}'
  parent: resSpokeVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: existingHubVNet.id  // Correctly referencing the Hub VNet by ID
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// ----- Output Spoke VNet ID for Use in Hub Peering Module -----
output spokeVNetId string = resSpokeVirtualNetwork.id

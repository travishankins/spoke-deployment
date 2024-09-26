// modules/deployInfrastructure.bicep

@description('Project name prefix to be added to all resource names.')
param parProjectPrefix string

@description('Project name prefix to be added to all resource names.')
param  parEnvironmentPrefix string

@description('The Azure Region to deploy the resources into.')
param parLocation string

@description('Tags to apply to all resources in this module.')
param parTags object

@description('Spoke network address prefix.')
param parSpokeNetworkAddressPrefix string

@description('Spoke subnet address CIDR.')
param paraddressPrefix string

@description('Spoke network name.')
param parSpokeNetworkName string = 'vnet-spoke-ncus'

@description('DNS Server IP addresses for the VNet.')
param parDnsServerIps array

@description('Next hop IP address.')
param parNextHopIpAddress string

// ----- Virtual Network -----
resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: '${parProjectPrefix}-${parEnvironmentPrefix}-${parSpokeNetworkName}'
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
  name: '${parProjectPrefix}-rt-ncus'
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

// ----- Subnet -----
resource resSpokeSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  parent: resSpokeVirtualNetwork
  name: '${parProjectPrefix}-${parEnvironmentPrefix}-snet-ncus-01'
  properties: {
    addressPrefix: paraddressPrefix
    routeTable: !empty(parNextHopIpAddress) ? {
      id: resSpokeToHubRouteTable.id
    } : null
  }
}

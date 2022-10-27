
param privateEndpointName string
param virtualNetworkId string
param location string = resourceGroup().location
param storageAccountId string
param privateDnsZoneId string
param privatelinkDnsZoneConfig string
param subnet string


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: privateEndpointName
  location: location
  tags: { }
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [
            'file'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: '${virtualNetworkId}/subnets/${subnet}'
    }
    customDnsConfigs: []
  }
}

resource privateEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent:privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privatelinkDnsZoneConfig
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

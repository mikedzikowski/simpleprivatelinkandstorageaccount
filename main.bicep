
targetScope = 'subscription'

param subscriptionId string = 'e121d000-54c3-45ff-bd0e-afd6686e8c1e'
param resourceGroupName string = 'testrg'
param privateEndpointName string = 'privateEndpointStorage'
param storageAccountName string = 'pltesting'
param virtualNetworkId string = '/subscriptions/e121d000-54c3-45ff-bd0e-afd6686e8c1e/resourceGroups/rg-nonproduction-usgovvirginia-01/providers/Microsoft.Network/virtualNetworks/vnet-nonproduction-usgovvirginia-01'
param privateDnsZonesId string = '/subscriptions/f4972a61-1083-4904-a4e2-a790107320bf/resourceGroups/rg-sharedservices-til-001/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.usgovcloudapi.net'
param privatelinkDnsZoneConfig string = 'privatelink-file-core-usgovcloudapi-net'
param subnetName string = 'default'
param location string = 'usgovvirginia'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  scope: resourceGroup(subscriptionId, resourceGroupName)
  name: storageAccountName
}

module privateEndpoint './modules/privateEndpoint.bicep' = {
  scope: resourceGroup(subscriptionId, resourceGroupName)
  name: 'pe-${storageAccountName}'
  params:{
    location: location
    storageAccountId: storageAccount.id
    privateEndpointName: privateEndpointName
    virtualNetworkId:virtualNetworkId
    privateDnsZoneId: privateDnsZonesId
    privatelinkDnsZoneConfig: privatelinkDnsZoneConfig
    subnet: subnetName
  }
  dependsOn: [
   rg
  ]
}

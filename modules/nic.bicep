
param storageAccountName string
param virtualNetworkId string
param subnetName string
param location string = resourceGroup().location
param guid string = newGuid()
var nicName = 'storagepl.nic.${storageAccountName}'

resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nicName
  location: location
  tags: {}
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.${guid}'
        properties: {
          privateIPAddress: null
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetworkId}/subnets/${subnetName}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

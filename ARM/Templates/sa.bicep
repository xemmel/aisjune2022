targetScope = 'resourceGroup'

param storageAccountName string
param location string = resourceGroup().location

var kind = 'StorageV2'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_GRS'
  }
  kind: kind
  
}

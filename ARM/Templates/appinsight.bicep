targetScope = 'resourceGroup'

param appName string
param env string
param workspaceId string
param location string = resourceGroup().location

var appInsightName = 'appi-${appName}-${env}'
var kind = 'web'

resource appInsight 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: kind
  properties: {
    WorkspaceResourceId: workspaceId
    Application_Type: kind
  }
}

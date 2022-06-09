targetScope = 'resourceGroup'

param appName string
param env string
param location string = resourceGroup().location


module workspace 'loganalytics.bicep' = {
  name: 'workspace'
  params: {
    appName: appName
    env: env
    location:location
  }
}

module appInsight 'appinsight.bicep' = {
  name: 'appInsight'
  params: {
    appName: appName
    env: env
    location: location
    workspaceId: workspace.outputs.id
  }
}

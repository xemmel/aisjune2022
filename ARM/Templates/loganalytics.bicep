targetScope = 'resourceGroup'

param appName string
param env string
param location string = resourceGroup().location

var workspaceName = 'log-${appName}-${env}'


resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
}

output id string = workspace.id

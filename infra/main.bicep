targetScope='subscription'

param cloudArenaRGName string
param logicAppCreateInstanceName string
param logicAppDeleteInstanceName string
param tagsLogicApp object
param cRoleRGManagerId string


module deployLogicApps 'modules/create-logicapps.instances.bicep' = {
  name: 'deployLogicApps'
  scope: resourceGroup(cloudArenaRGName)
  params: {
    cloudArenaRGName: cloudArenaRGName
    logicAppCreateInstanceName: logicAppCreateInstanceName
    logicAppDeleteInstanceName: logicAppDeleteInstanceName
    tags: tagsLogicApp
  }
}

module deployLogicAppsAuth 'modules/create-logicapps.instances.auth.bicep' = {
  name: 'deployLogicAppsAuth'
  scope: resourceGroup(cloudArenaRGName)
  params: {
    cloudArenaRGName: cloudArenaRGName
    logicAppCreateInstanceName: logicAppCreateInstanceName
    logicAppDeleteInstanceName: logicAppDeleteInstanceName
    cRoleId: cRoleRGManagerId
  }
  dependsOn: [
    deployLogicApps
  ]
}

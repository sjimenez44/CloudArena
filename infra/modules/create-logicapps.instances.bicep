param cloudArenaRGName string
param logicAppCreateInstanceName string
param logicAppDeleteInstanceName string
param tags object


module logicAppCreateInstance '../logicapp/create-logicapp.bicep' = {
  name: 'logicAppCreateInstance'
  scope: resourceGroup(cloudArenaRGName)
  params: {
    logicAppState: 'Enabled'
    useIdentity: 'SMI'
    logicAppName: logicAppCreateInstanceName
    definition: loadTextContent('../../code/logicapps/logicapp-createInstance.definition.json')
    tags: tags
  }
}

module logicAppDeleteInstance '../logicapp/create-logicapp.bicep' = {
  name: 'logicAppDeleteInstance'
  scope: resourceGroup(cloudArenaRGName)
  params: {
    logicAppState: 'Enabled'
    useIdentity: 'SMI'
    logicAppName: logicAppDeleteInstanceName
    definition: loadTextContent('../../code/logicapps/logicapp-deleteInstance.definition.json')
    tags: tags
  }
  dependsOn: [
    logicAppCreateInstance
  ]
}

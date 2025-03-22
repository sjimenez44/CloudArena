param cloudArenaRGName string
param logicAppCreateInstanceName string
param logicAppDeleteInstanceName string
param cRoleId string


resource logicAppCreateInstanceRG 'Microsoft.Logic/workflows@2019-05-01' existing = {
  name: logicAppCreateInstanceName
  scope: resourceGroup(cloudArenaRGName)
}

resource logicAppDeleteInstanceRG 'Microsoft.Logic/workflows@2019-05-01' existing = {
  name: logicAppDeleteInstanceName
  scope: resourceGroup(cloudArenaRGName)
}

module logicAppRoleAssignmentCreateInstance '../auth/create-roleassignment.subs.bicep' = {
  name: 'logicAppRoleAssignmentCreateInstance'
  scope: subscription()
  params: {
    principalId: logicAppCreateInstanceRG.identity.principalId
    principalType: 'ServicePrincipal'
    roleId: cRoleId
  }
}

module logicAppRoleAssignmentDeleteInstance '../auth/create-roleassignment.subs.bicep' = {
  name: 'logicAppRoleAssignmentDeleteInstance'
  scope: subscription()
  params: {
    principalId: logicAppDeleteInstanceRG.identity.principalId
    principalType: 'ServicePrincipal'
    roleId: cRoleId
  }
}

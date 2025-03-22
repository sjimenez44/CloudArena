@description('Specifies the type of principal to assign the role. Allowed values: User, Group, ServicePrincipal.')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
])
param principalType string
@description('The unique identifier of the role definition to assign.')
param roleId string
@description('The unique object ID of the user, group, or service principal receiving the role assignment.')
param principalId string
@description('Indicates whether a condition should be applied to the role assignment.')
param withCondition bool = false
@description('Specifies the condition expression for the role assignment if withCondition is set to true.')
param conditionValue string = ''


var roleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: 'ra-${guid(subscription().id, resourceGroup().id, roleId, principalId)}'
  properties: {
    principalType: principalType
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    description: withCondition ? 'Role assignment condition created with a Bicep file' : null
    condition: withCondition ? conditionValue : null
    conditionVersion: withCondition ? '2.0' : null
  }
}

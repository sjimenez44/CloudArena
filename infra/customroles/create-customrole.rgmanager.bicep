resource cRoleRGManager 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, 'Custom RG Manager')
  properties: {
    roleName: 'Custom RG Manager'
    description: 'Role to manage Resource Groups and view deployments'
    permissions: [
      {
        actions: [
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Resources/subscriptions/resourceGroups/write'
          'Microsoft.Resources/subscriptions/resourceGroups/delete'
          'Microsoft.Resources/deployments/read'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

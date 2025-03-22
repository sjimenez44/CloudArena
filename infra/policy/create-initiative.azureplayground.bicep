targetScope = 'subscription'

param versionName string

resource policyDefinitionNotAllowedResourceType 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Not_Allowed_Resource_Type-1.0.0'
}


resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2025-01-01' = {
  name: 'pid-Azure_Playground-${versionName}'
  properties: {
    displayName: 'Azure_Playground'
    description: 'Policy Set Definition to define global restrictions'
    policyType: 'Custom'
    metadata: {
      category : 'Global Restriction'
    }
    version: versionName
    policyDefinitions: [
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionNotAllowedResourceType.name)
      }
    ]
    
  }
}

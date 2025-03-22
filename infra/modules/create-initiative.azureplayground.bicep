targetScope = 'subscription'


module policyDefinitionNotAllowedResourceType '../policy/create-policy.notallowedresourcetype.bicep' = {
  name: 'policyDefinitionNotAllowedResourceType'
  params: {
    versionName: '1.0.0'
  }
}


module policySetDefinitionAzurePlayground '../policy/create-initiative.azureplayground.bicep' = {
  name: 'policySetDefinitionAzurePlayground'
  params: {
    versionName: '1.0.0'
  }
  dependsOn: [
    policyDefinitionNotAllowedResourceType
  ]
}

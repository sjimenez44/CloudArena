targetScope = 'subscription'


module policyDefinitionApiManagement '../policy/create-policy.apimanagement.bicep' = {
  name: 'policyDefinitionApiManagement'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionAppService '../policy/create-policy.appservice.bicep' = {
  name: 'policyDefinitionAppService'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionContainerRegistry '../policy/create-policy.containerregistry.bicep' = {
  name: 'policyDefinitionContainerRegistry'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionEventGrid '../policy/create-policy.eventgrid.bicep' = {
  name: 'policyDefinitionEventGrid'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionEventHub '../policy/create-policy.eventhub.bicep' = {
  name: 'policyDefinitionEventHub'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionKeyVault '../policy/create-policy.keyvault.bicep' = {
  name: 'policyDefinitionKeyVault'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionServiceBus '../policy/create-policy.servicebus.bicep' = {
  name: 'policyDefinitionServiceBus'
  params: {
    versionName: '1.0.0'
  }
}

module policyDefinitionStorageAccount '../policy/create-policy.storageaccount.bicep' = {
  name: 'policyDefinitionStorageAccount'
  params: {
    versionName: '1.0.0'
  }
}


module policySetDefinitionGlobalRestriction '../policy/create-initiative.globalrestrictions.bicep' = {
  name: 'policySetDefinitionGlobalRestriction'
  params: {
    versionName: '1.0.0'
  }
  dependsOn: [
    policyDefinitionApiManagement
    policyDefinitionAppService
    policyDefinitionContainerRegistry
    policyDefinitionEventGrid
    policyDefinitionEventHub
    policyDefinitionKeyVault
    policyDefinitionServiceBus
    policyDefinitionStorageAccount
  ]
}

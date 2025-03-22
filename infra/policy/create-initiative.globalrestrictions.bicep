targetScope = 'subscription'

param versionName string

resource policyDefinitionAllowedLocations 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Allowed_Locations-1.0.0'
}

resource policyDefinitionApiManagement 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-API_Management-1.0.0'
}

resource policyDefinitionAppService 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-App_Service-1.0.0'
}

resource policyDefinitionContainerApp 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Container_App-1.0.0'
}

resource policyDefinitionContainerInstance 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Container_Instance-1.0.0'
}

resource policyDefinitionContainerRegistry 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Container_Registry-1.0.0'
}

resource policyDefinitionContainerService 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Container_Service-1.0.0'
}

resource policyDefinitionEventGrid 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Event_Grid-1.0.0'
}

resource policyDefinitionEventHub 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Event_Hub-1.0.0'
}

resource policyDefinitionKeyVault 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Key_Vault-1.0.0'
}

resource policyDefinitionLogAnalytics 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Log_Analytics-1.0.0'
}

resource policyDefinitionServiceBus 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Service_Bus-1.0.0'
}

resource policyDefinitionStorageAccount 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: 'pd-Storage_Account-1.0.0'
}


resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2025-01-01' = {
  name: 'pid-Global_Restriction-${versionName}'
  properties: {
    displayName: 'Global_Restriction'
    description: 'Policy Set Definition to define global restrictions'
    policyType: 'Custom'
    metadata: {
      category : 'Global Restriction'
    }
    version: versionName
    policyDefinitions: [
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionAllowedLocations.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionApiManagement.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionAppService.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionContainerApp.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionContainerInstance.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionContainerRegistry.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionContainerService.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionEventGrid.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionEventHub.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionKeyVault.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionLogAnalytics.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionServiceBus.name)
      }
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionStorageAccount.name)
      }
    ]
    
  }
}

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Container_Registry-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Container_Registry'
    description: 'This policy allows to define the permitted skus for the Container Registry'
    policyType: 'Custom'
    metadata: {
      category : 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedSkus: {
        type: 'array'
        metadata: {
          displayName: 'Allowed SKUs'
          description: 'The list of SKUs can be used for the Container Registry (e.g. Basic)'
        }
        allowedValues: [
          'Basic'
          'Standard'
          'Premium'
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ContainerRegistry/registries'
          }
          {
            not: {
              field: 'Microsoft.ContainerRegistry/registries/sku.name'
              in: '[parameters(\'allowedSkus\')]'
            }
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

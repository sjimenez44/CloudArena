targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Storage_Account-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Storage_Account'
    description: 'This policy allows to define the permitted skus for the Storage Account'
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
          description: 'The list of SKUs can be used for the Storage Account (e.g. LRS)'
        }
        allowedValues: [
          'Standard_LRS'
          'Standard_GRS'
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            not: {
              field: 'Microsoft.Storage/storageAccounts/sku.name'
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

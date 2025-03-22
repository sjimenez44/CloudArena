targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-App_Service-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'App_Service'
    description: 'This policy allows to define the permitted skus for the App Service'
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
          description: 'The list of SKUs can be used for the App Service (e.g. LRS)'
        }
        allowedValues: [
          'Free'
          'Basic'
          'B1'
          'F1'
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Web/serverfarms'
          }
          {
            not: {
              allOf: [
                {
                  field: 'Microsoft.Web/serverfarms/sku.name'
                  in: '[parameters(\'allowedSkus\')]'
                }
                {
                  field: 'Microsoft.Web/serverfarms/sku.tier'
                  in: '[parameters(\'allowedSkus\')]'
                }
              ]
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

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-${guid(subscription().id, 'API_Management', versionName)}'
  properties: {
    mode: 'All'
    displayName: 'API_Management'
    description: 'This policy allows to define the permitted skus for the API Management'
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
          description: 'The list of SKUs can be used for the API Management (e.g. Basic)'
        }
        allowedValues: [
          'Basic'
          'BasicV2'
          'Consumption'
          'Developer'
          'Isolated'
          'Premium'
          'Standard'
          'StandardV2'
        ]
        defaultValue: []
      }
      maxSkuCapacity: {
        type: 'Integer'
        metadata: {
          displayName: 'Maximum SKU capacity'
          description: 'The maximum allowed capacity for API Management SKU'
        }
        defaultValue: 1
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ApiManagement/service'
          }
          {
            not: {
              allOf: [
                {
                  field: 'Microsoft.ApiManagement/service/sku.name'
                  in: '[parameters(\'allowedSkus\')]'
                }
                {
                  field: 'Microsoft.ApiManagement/service/sku.capacity'
                  lessOrEquals: '[parameters(\'maxSkuCapacity\')]'
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

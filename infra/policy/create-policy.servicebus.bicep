targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Service_Bus-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Service_Bus'
    description: 'This policy allows to define the permitted skus for the Service Bus'
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
          description: 'The list of SKUs can be used for the Service Bus Namespaces (e.g. LRS)'
        }
        allowedValues: [
          'Basic'
          'Standard'
          'Premium'
        ]
        defaultValue: []
      }
      maxSkuCapacity: {
        type: 'Integer'
        metadata: {
          displayName: 'Maximum SKU capacity'
          description: 'The maximum allowed capacity for Service Bus Namespaces SKU'
        }
        defaultValue: 1
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ServiceBus/namespaces'
          }
          {
            not: {
              allOf: [
                {
                  field: 'Microsoft.ServiceBus/namespaces/sku.name'
                  in: '[parameters(\'allowedSkus\')]'
                }
                {
                  field: 'Microsoft.ServiceBus/namespaces/sku.capacity'
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

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Event_Grid-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Event_Grid'
    description: 'This policy allows to define the permitted skus for the Event Grid'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedEventGridKind: {
        type: 'String'
        metadata: {
          displayName: 'Allowed Event Grid Kind'
          description: 'The allowed kind for Event Grid topics'
        }
        defaultValue: 'Azure'
      }
      allowedEventGridSku: {
        type: 'String'
        metadata: {
          displayName: 'Allowed Event Grid SKU'
          description: 'The allowed SKU name for Event Grid topics'
        }
        defaultValue: 'Basic'
      }
    }
    policyRule: {
      if: {
        anyOf: [
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.EventGrid/topics'
              }
              {
                not: {
                  allOf: [
                    {
                      field: 'kind'
                      equals: '[parameters(\'allowedEventGridKind\')]'
                    }
                    {
                      anyOf: [
                        {
                          field: 'Microsoft.EventGrid/topics/sku.name'
                          equals: '[parameters(\'allowedEventGridSku\')]'
                        }
                        {
                          field: 'Microsoft.EventGrid/topics/sku.name'
                          exists: false
                        }
                      ]
                    }
                    {
                      field: 'Microsoft.EventGrid/topics/dataResidencyBoundary'
                      equals: 'WithinRegion'
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.EventGrid/namespaces'
              }
              {
                not: {
                  allOf: [
                    {
                      field: 'Microsoft.EventGrid/namespaces/sku.name'
                      equals: 'Standard'
                    }
                    {
                      field: 'Microsoft.EventGrid/namespaces/sku.capacity'
                      lessOrEquals: 1
                    }
                    {
                      field: 'Microsoft.EventGrid/namespaces/isZoneRedundant'
                      equals: false
                    }
                  ]
                }
              }
            ]
          }
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.EventGrid/domains'
              }
              {
                not: {
                  allOf: [
                    {
                      anyOf: [
                        {
                          field: 'Microsoft.EventGrid/domains/sku.name'
                          equals: 'Basic'
                        }
                        {
                          field: 'Microsoft.EventGrid/domains/sku.name'
                          exists: false
                        }
                      ]
                    }
                    {
                      field: 'Microsoft.EventGrid/domains/dataResidencyBoundary'
                      equals: 'WithinRegion'
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

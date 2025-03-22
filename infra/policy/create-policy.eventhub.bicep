targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Event_Hub-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Event_Hub'
    description: 'This policy allows to define the permitted skus for the Event Hub'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedSkuTiers: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed SKU Tiers'
          description: 'List of allowed SKU tiers for Event Hub namespaces'
        }
        allowedValues: [
          'Basic'
          'Standard'
        ]
        defaultValue: []
      }
      captureEnabled: {
        type: 'Boolean'
        metadata: {
          displayName: 'Capture Enabled'
          description: 'Specifies if Event Capture must be enabled'
        }
        defaultValue: false
      }
      autoInflateEnabled: {
        type: 'Boolean'
        metadata: {
          displayName: 'Auto Inflate Enabled'
          description: 'Specifies if Auto Inflate must be enabled'
        }
        defaultValue: false
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.EventHub/namespaces'
          }
          {
            anyOf: [
              {
                not: {
                  field: 'Microsoft.EventHub/namespaces/sku.tier'
                  in: '[parameters(\'allowedSkuTiers\')]'
                }
              }
              {
                allOf: [
                  {
                    field: 'Microsoft.EventHub/namespaces/captureDescription.enabled'
                    exists: true
                  }
                  {
                    field: 'Microsoft.EventHub/namespaces/captureDescription.enabled'
                    equals: '[parameters(\'captureEnabled\')]'
                  }
                ]
              }
              {
                allOf: [
                  {
                    field: 'Microsoft.EventHub/namespaces/isAutoInflateEnabled'
                    exists: true
                  }
                  {
                    field: 'Microsoft.EventHub/namespaces/isAutoInflateEnabled'
                    equals: '[parameters(\'autoInflateEnabled\')]'
                  }
                ]
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

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Container_Instance-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Container_Instance'
    description: 'Restrictions for container instances'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedSku: {
        type: 'array'
        metadata: {
          displayName: 'Allowed SKU'
          description: 'The allowed SKU for container groups.'
        }
        allowedValues: [
          'Standard'
        ]
        defaultValue: []
      }
      allowedCpu: {
        type: 'array'
        metadata: {
          displayName: 'Allowed CPU'
          description: 'The allowed CPU values for containers.'
        }
        allowedValues: [
          0,25
          0,5
          0,75
          1
          1,25
          1,5
          1,75
          2
        ]
        defaultValue: []
      }
      allowedMemory: {
        type: 'array'
        metadata: {
          displayName: 'Allowed Memory (GB)'
          description: 'The allowed memory values for containers (in GB).'
        }
        allowedValues: [
          0,5
          1
          1,5
          2
          2,5
          3
          3,5
          4
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ContainerInstance/containerGroups'
          }
          {
            not: {
              allOf: [
                {
                  field: 'Microsoft.ContainerInstance/containerGroups/sku'
                  equals: '[parameters(\'allowedSku\')]'
                }
                {
                  field: 'Microsoft.ContainerInstance/containerGroups/containers[*].resources.requests.cpu'
                  in: '[parameters(\'allowedCpu\')]'
                }
                {
                  field: 'Microsoft.ContainerInstance/containerGroups/containers[*].resources.requests.memoryInGB'
                  in: '[parameters(\'allowedMemory\')]'
                }
                {
                  field: 'Microsoft.ContainerInstance/containerGroups/diagnostics.logAnalytics'
                  exists: false
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

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Container_Service-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Container_Service'
    description: 'Restrictions for container service'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedVmSizes: {
        type: 'array'
        metadata: {
          displayName: 'Allowed VM Sizes'
          description: 'List of allowed VM sizes for agent pools.'
        }
        allowedValues: [
          'Standard_D2s_v3'
          'Standard_K8S2_v1'
          'Standard_K8S_v1'
        ]
        defaultValue: []
      }
      maxAgentPoolCount: {
        type: 'Integer'
        metadata: {
          displayName: 'Max Agent Pool Count'
          description: 'The maximum count for the agent pool nodes.'
        }
        defaultValue: 2
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ContainerService/managedClusters'
          }
          {
            not: {
              allOf: [
                {
                  field: 'Microsoft.ContainerService/managedClusters/agentPoolProfiles[*].vmSize'
                  equals: '[parameters(\'allowedVmSizes\')]'
                }
                {
                  field: 'Microsoft.ContainerService/managedClusters/agentPoolProfiles[*].maxCount'
                  lessOrEquals: '[parameters(\'maxAgentPoolCount\')]'
                }
                {
                  field: 'Microsoft.ContainerService/managedClusters/agentPoolProfiles[*].count'
                  lessOrEquals: '[parameters(\'maxAgentPoolCount\')]'
                }
                {
                  count: {
                    field: 'Microsoft.ContainerService/managedClusters/agentPoolProfiles[*]'
                  }
                  lessOrEquals: 1
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

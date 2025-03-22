targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Container_App-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Container_App'
    description: 'Restriction for managed environments and container app'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedWorkloadProfile: {
        type: 'array'
        metadata: {
          displayName: 'Allowed Workload Profile Type'
          description: 'The allowed workload profile type for managed environments.'
        }
        allowedValues: [
          'Consumption'
        ]
        defaultValue: []
      }
      allowedZoneRedundancy: {
        type: 'Boolean'
        metadata: {
          displayName: 'Allowed Zone Redundancy'
          description: 'Indicates whether zone redundancy is allowed in managed environments.'
        }
        defaultValue: false
      }
      allowedMinReplicas: {
        type: 'array'
        metadata: {
          displayName: 'Allowed Min Replicas'
          description: 'Allowed minimum replicas for container apps.'
        }
        allowedValues: [
          0
          1
        ]
        defaultValue: []
      }
      allowedMaxReplicas: {
        type: 'array'
        metadata: {
          displayName: 'Allowed Max Replicas'
          description: 'Allowed maximum replicas for container apps.'
        }
        allowedValues: [
          0
          1
          2
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        anyOf: [
          {
            allOf: [
              {
                field: 'type'
                equals: 'Microsoft.App/managedEnvironments'
              }
              {
                not: {
                  allOf: [
                    {
                      field: 'Microsoft.App/managedEnvironments/workloadProfiles[*].workloadProfileType'
                      equals: '[parameters(\'allowedWorkloadProfile\')]'
                    }
                    {
                      anyOf: [
                        {
                          field: 'Microsoft.App/managedEnvironments/zoneRedundant'
                          equals: '[parameters(\'allowedZoneRedundancy\')]'
                        }
                        {
                          field: 'Microsoft.App/managedEnvironments/zoneRedundant'
                          exists: false
                        }
                      ]
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
                equals: 'Microsoft.App/containerApps'
              }
              {
                not: {
                  allOf: [
                    {
                      field: 'Microsoft.App/containerApps/template.scale.minReplicas'
                      in: '[parameters(\'allowedMinReplicas\')]'
                    }
                    {
                      anyOf: [
                        {
                          field: 'Microsoft.App/containerApps/template.scale.maxReplicas'
                          in: '[parameters(\'allowedMaxReplicas\')]'
                        }
                        {
                          field: 'Microsoft.App/containerApps/template.scale.maxReplicas'
                          exists: false
                        }
                      ]
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

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Log_Analytics-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Log_Analytics'
    description: 'Restriction based on Logs analytics workspace'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      allowedLogAnalyticsSku: {
        type: 'array'
        metadata: {
          displayName: 'Allowed Log Analytics SKU'
          description: 'The allowed SKU for Log Analytics workspaces.'
        }
        allowedValues: [
          'PerGB2018'
        ]
        defaultValue: []
      }
      maxRetentionDays: {
        type: 'Integer'
        metadata: {
          displayName: 'Maximum Retention Days'
          description: 'The maximum allowed retention period in days for Log Analytics workspaces.'
        }
        defaultValue: 90
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.OperationalInsights/workspaces'
          }
          {
            not: {
              allOf: [
                {
                  field: 'Microsoft.OperationalInsights/workspaces/sku.name'
                  equals: '[parameters(\'allowedLogAnalyticsSku\')]'
                }
                {
                  anyOf: [
                    {
                      field: 'Microsoft.OperationalInsights/workspaces/retentionInDays'
                      lessOrEquals: '[parameters(\'allowedLogAnalyticsSku\')]'
                    }
                    {
                      field: 'Microsoft.OperationalInsights/workspaces/retentionInDays'
                      exists: false
                    }
                  ]
                }
                {
                  anyOf: [
                    {
                      field: 'Microsoft.OperationalInsights/workspaces/workspaceCapping.dailyQuotaGb'
                      in: [
                        -1
                        1
                      ]
                    }
                    {
                      field: 'Microsoft.OperationalInsights/workspaces/workspaceCapping.dailyQuotaGb'
                      exists: false
                    }
                  ]
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

targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Key_Vault-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Key_Vault'
    description: 'This policy allows to define the permitted skus for the Key Vault'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      purgeProtectionEnabled: {
        type: 'Boolean'
        metadata: {
          displayName: 'Purge Protection Enabled'
          description: 'Specifies whether purge protection is enabled for the Key Vault.'
        }
        defaultValue: true
      }
      createMode: {
        type: 'String'
        metadata: {
          displayName: 'Create Mode'
          description: 'Specifies the create mode for the Key Vault.'
        }
        defaultValue: 'recover'
      }
      allowedSkus: {
        type: 'array'
        metadata: {
          displayName: 'Allowed SKUs'
          description: 'The list of SKUs can be used for the Key Vault (e.g. LRS)'
        }
        allowedValues: [
          'Standard'
        ]
        defaultValue: []
      }
      softDeleteRetentionDays: {
        type: 'Integer'
        metadata: {
          displayName: 'Soft Delete Retention Days'
          description: 'Specifies the required soft delete retention period in days.'
        }
        defaultValue: 15
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.KeyVault/vaults'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.KeyVault/vaults/enablePurgeProtection'
                equals: '[parameters(\'purgeProtectionEnabled\')]'
              }
              {
                field: 'Microsoft.KeyVault/vaults/createMode'
                equals: '[parameters(\'createMode\')]'
              }
              {
                not: {
                  field: 'Microsoft.KeyVault/vaults/sku.name'
                  in: '[parameters(\'allowedSkus\')]'
                }
              }
              {
                not: {
                  field: 'Microsoft.KeyVault/vaults/softDeleteRetentionInDays'
                  lessOrEquals: '[parameters(\'softDeleteRetentionDays\')]'
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

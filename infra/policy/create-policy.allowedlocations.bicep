targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Allowed_Locations-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Allowed_Locations'
    description: 'This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the \'global\' region.'
    policyType: 'Custom'
    metadata: {
      category : 'Global Restriction'
    }
    version: versionName
    parameters: {
      listOfAllowedLocations: {
        type: 'array'
        metadata: {
          displayName: 'Allowed SKUs'
          description: 'The list of allowed locations (e.g. East US)'
        }
        allowedValues: [
          'eastus'
          'eastus2'
          'westus'
          'westus2'
          'centralus'
          'centralus2'
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'location'
            notIn: '[parameters(\'listOfAllowedLocations\')]'
          }
          {
            field: 'location'
            notEquals: 'global'
          }
          {
            field: 'type'
            notEquals: 'Microsoft.AzureActiveDirectory/b2cDirectories'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

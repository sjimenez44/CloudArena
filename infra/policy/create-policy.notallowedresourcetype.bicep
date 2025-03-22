targetScope = 'subscription'

param versionName string

resource policyDefintion 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: 'pd-Not_Allowed_Resource_Type-${versionName}'
  properties: {
    mode: 'All'
    displayName: 'Not_Allowed_Resource_Type'
    description: 'This policy allows to define the not allowed resource types'
    policyType: 'Custom'
    metadata: {
      category: 'Global Restriction'
    }
    version: versionName
    parameters: {
      notAllowedResourceTypes: {
        type: 'array'
        metadata: {
          displayName: 'Not Allowed Resource Types'
          description: 'The list of Resource Types. Any request with this resource type included will be denied.'
        }
        allowedValues: [
          'Microsoft.Compute/virtualMachines'
          'Microsoft.Compute/virtualMachineScaleSets'
          'Microsoft.Compute/availabilitySets'
          'Microsoft.Compute/disks'
          'Microsoft.Compute/sshPublicKeys'
          'Microsoft.Compute/virtualMachines/extensions'
          'Microsoft.Storage/storageAccounts'
          'Microsoft.Network/networkInterfaces'
          'Microsoft.Network/networkSecurityGroups'
          'Microsoft.Network/publicIPAddresses'
          'Microsoft.Network/virtualNetworks'
          'Microsoft.Network/privateEndpoints'
          'Microsoft.Network/privateDnsZones'
          'Microsoft.Network/privateDnsZones/virtualNetworkLinks'
          'Microsoft.Network/loadBalancers'
          'Microsoft.Network/routeTables'
          'Microsoft.Network/firewallPolicies'
          'Microsoft.Network/azureFirewalls'
          'Microsoft.Network/applicationGateways'
          'Microsoft.DocumentDB/databaseAccounts'
          'Microsoft.Web/serverFarms'
          'Microsoft.Web/sites'
          'Microsoft.Sql/servers'
          'Microsoft.Sql/servers/databases'
          'Microsoft.ManagedIdentity/userAssignedIdentities'
          'Microsoft.ContainerService/managedClusters'
          'Microsoft.ContainerService/managedClusters/agentPools'
          'Microsoft.DataLakeAnalytics/accounts'
          'Microsoft.Synapse/workspaces'
          'Microsoft.Logic/workflows'
          'Microsoft.KeyVault/vaults'
          'Microsoft.MachineLearningServices/workspaces'
          'Microsoft.OperationalInsights/workspaces'
          'Microsoft.SecurityInsights/workspaces'
          'Microsoft.ContainerRegistry/registries'
          'Microsoft.ContainerRegistry/registries/replications'
          'Microsoft.ServiceBus/namespaces'
          'Microsoft.EventHub/namespaces'
          'Microsoft.ApiManagement/service'
          'Microsoft.App/containerApps'
          'Microsoft.App/managedEnvironments'
          'Microsoft.Cdn/profiles'
          'microsoft.cdn/profiles/endpoints'
          'Microsoft.Cdn/Profiles/AfdEndpoints'
          'Microsoft.Cdn/Profiles/OriginGroups'
          'Microsoft.Cdn/Profiles/OriginGroups/Origins'
          'Microsoft.Cdn/Profiles/AfdEndpoints/Routes'
          'Microsoft.Network/frontdoors'
          'Microsoft.ContainerInstance/containerGroups'
          'Microsoft.OperationalInsights/workspaces'
          'Microsoft.EventGrid/topics'
          'Microsoft.EventGrid/namespaces'
          'Microsoft.EventGrid/domains'
        ]
        defaultValue: []
      }
    }
    policyRule: {
      if: {
        not: {
          field: 'type'
          in: '[parameters(\'notAllowedResourceTypes\')]'
        }
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

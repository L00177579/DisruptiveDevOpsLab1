param sqlServerPrimaryName string
@secure()
param sqlServerPrimaryAdminLoginPassword string
param sqlServerPrimaryAdminLogin string
param primaryLocation string = resourceGroup().location

param sqlServerSecondaryName string
@secure()
param sqlServerSecondaryAdminLoginPassword string
param sqlServerSecondaryAdminLogin string
param SecondaryLocation string = resourceGroup().location

param sqlServerFailoverGroupName string

param sqlServerDatabaseNames array

module sqlServerPrimary 'modules/sqlserver.bicep' = {
  name: 'sqlserverprimary_module'
  params: {
    sqlServerName: sqlServerPrimaryName
    sqlServerAdminLoginPassword: sqlServerPrimaryAdminLoginPassword
    sqlServerDatabaseNames: sqlServerDatabaseNames
    sqlServerAdminLogin: sqlServerPrimaryAdminLogin
    location: primaryLocation
  }
}

module sqlServerSecondary 'modules/sqlserver.bicep' = {
  name: 'sqlserversecondary_module'
  params: {
    sqlServerName: sqlServerSecondaryName
    sqlServerAdminLoginPassword: sqlServerSecondaryAdminLoginPassword
    sqlServerDatabaseNames: []
    sqlServerAdminLogin: sqlServerSecondaryAdminLogin
    location: SecondaryLocation
  }
}

resource sqlServerFailoverGroup 'Microsoft.Sql/servers/failoverGroups@2022-02-01-preview' = {
  name: '${sqlServerPrimaryName}/${sqlServerFailoverGroupName}'
  properties: {
    databases: sqlServerDatabaseNames
    readWriteEndpoint: {
      failoverPolicy: 'Automatic'
      failoverWithDataLossGracePeriodMinutes: 60
    }
    readOnlyEndpoint: {
      failoverPolicy: 'Enabled'
    }
    partnerServers: [
      {
        id: sqlServerSecondary.outputs.sqlServerId
      }
    ]
  }
}

param sqlServerPrimaryName string
@secure()
param sqlServerPrimaryAdminLoginPassword string
param sqlServerPrimaryAdminLogin string
param primaryLocation string = resourceGroup().location

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

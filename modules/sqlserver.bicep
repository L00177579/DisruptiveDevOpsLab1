param sqlServerName string
param sqlServerAdminLogin string
@secure()
param sqlServerAdminLoginPassword string
param sqlServerDatabaseNames array
param location string = resourceGroup().location


resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    name: 'sqlserver'
  }
  properties: {
    administratorLogin: sqlServerAdminLogin
    administratorLoginPassword: sqlServerAdminLoginPassword
  }
}

resource testDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = [for dbName in sqlServerDatabaseNames: {
  name: dbName
  parent: sqlServer
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  properties: {
    sourceDatabaseId: sqlServer.id
  }
}]

output sqlServerId string = sqlServer.id

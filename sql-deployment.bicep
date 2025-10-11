// Azure SQL Database deployment with correct SKU configuration

param location string = resourceGroup().location
param sqlServerName string = 'sqlserver-${uniqueString(resourceGroup().id)}'
param sqlDatabaseName string = 'sqldb-${uniqueString(resourceGroup().id)}'
param administratorLogin string
@secure()
param administratorLoginPassword string

// SQL Server resource
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
  }
}

// SQL Database with correct SKU configuration
// GP_S_Gen5_2 requires a minimum capacity of 2 vCores, not 1
resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: 'GP_S_Gen5_2'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2  // Fixed: Changed from 1 to 2 to match SKU requirements
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 34359738368  // 32 GB
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    autoPauseDelay: 60
    minCapacity: json('0.5')
  }
}

output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
output sqlDatabaseName string = sqlDatabase.name

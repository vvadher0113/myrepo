# Azure SQL Deployment Fix

## Problem
The deployment was failing with the error:
```
Mismatch between SKU name 'GP_S_Gen5_2' and capacity '1'.
```

## Root Cause
The Azure SQL Database SKU `GP_S_Gen5_2` (General Purpose Serverless Gen5) requires a minimum capacity of **2 vCores**, as indicated by the "2" in the SKU name. The deployment was attempting to use a capacity of 1, which is not supported for this SKU.

## Solution
The `sql-deployment.bicep` file has been created with the correct configuration:
- **SKU Name**: `GP_S_Gen5_2`
- **Capacity**: `2` (changed from 1 to match SKU requirements)
- **Tier**: `GeneralPurpose`
- **Family**: `Gen5`

## Alternative Options
If you need a lower capacity (1 vCore), you can use:
- `GP_S_Gen5_1` with capacity 1
- `Basic` tier with DTU-based pricing
- `Standard` tier (S0, S1, etc.) with DTU-based pricing

## Deployment Instructions

### Using Azure CLI
```bash
az deployment group create \
  --resource-group bicep-rg \
  --template-file sql-deployment.bicep \
  --parameters sql-deployment.parameters.json
```

### Using Azure PowerShell
```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName bicep-rg `
  -TemplateFile sql-deployment.bicep `
  -TemplateParameterFile sql-deployment.parameters.json
```

## Files Created
- `sql-deployment.bicep`: Main Bicep template with corrected SKU configuration
- `sql-deployment.parameters.json`: Parameters file (update with your specific values)

## Notes
- Update the parameters file with your actual Key Vault details for secure password management
- Adjust location, server name, and database name as needed
- The serverless configuration includes auto-pause after 60 minutes of inactivity

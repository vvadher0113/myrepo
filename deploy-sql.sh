#!/bin/bash

# Azure SQL Deployment Script
# This script deploys the Azure SQL Database with correct SKU configuration

set -e

# Configuration
RESOURCE_GROUP="bicep-rg"
LOCATION="eastus"
DEPLOYMENT_NAME="sqlDeployment"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI is not installed. Please install it from https://aka.ms/install-az-cli"
    exit 1
fi

# Check if logged in to Azure
echo "Checking Azure login status..."
if ! az account show &> /dev/null; then
    echo "Not logged in to Azure. Please run 'az login' first."
    exit 1
fi

# Get the subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "Using subscription: $SUBSCRIPTION_ID"

# Create resource group if it doesn't exist
echo "Ensuring resource group exists..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Deploy the Bicep template
echo "Deploying Azure SQL Database..."
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --name $DEPLOYMENT_NAME \
  --template-file sql-deployment.bicep \
  --parameters administratorLogin=sqladmin \
  --parameters administratorLoginPassword="$(openssl rand -base64 32 | tr -d '=' | head -c 32)"

echo "Deployment completed successfully!"
echo "Note: Please save the administrator password securely. It was auto-generated."

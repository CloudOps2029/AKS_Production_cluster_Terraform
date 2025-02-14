#!/bin/bash

RESOURCE_GROUP_NAME=backendrg
STORAGE_ACCOUNT_NAME=backendtf101
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location canadacentral

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME



################## POWERSHELL-WINDOWS BASED ###################################

# Define variables
$ResourceGroupName = "backend-rg"
$StorageAccountName = "backendsa101"
$ContainerName = "tfstate"
$Location = "canadacentral"

# Check if resource group exists
$rg = az group show --name $ResourceGroupName --query "name" -o tsv 2>$null
if (-not $rg) {
    Write-Host "Creating resource group: $ResourceGroupName"
    az group create --name $ResourceGroupName --location $Location
} else {
    Write-Host "Resource group $ResourceGroupName already exists."
}

# Check if storage account exists
$sa = az storage account show --name $StorageAccountName --resource-group $ResourceGroupName --query "name" -o tsv 2>$null
if (-not $sa) {
    Write-Host "Creating storage account: $StorageAccountName"
    az storage account create --resource-group $ResourceGroupName --name $StorageAccountName --sku Standard_LRS --encryption-services blob
} else {
    Write-Host "Storage account $StorageAccountName already exists."
}

# Get Storage Account Key
$StorageKey = az storage account keys list --resource-group $ResourceGroupName --account-name $StorageAccountName --query "[0].value" -o tsv

# Check if container exists
$containerExists = az storage container show --name $ContainerName --account-name $StorageAccountName --auth-mode key --query "name" -o tsv 2>$null
if (-not $containerExists) {
    Write-Host "Creating blob container: $ContainerName"
    az storage container create --name $ContainerName --account-name $StorageAccountName --account-key $StorageKey
} else {
    Write-Host "Blob container $ContainerName already exists."
}

Write-Host "Azure storage backend setup complete!"

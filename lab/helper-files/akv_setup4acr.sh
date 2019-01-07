#!/bin/sh
# Create Azure Keyvault and Support Azure Container Registry Secrets
# Parameters:
# $1 - Resource Group to use for Key Vault
# $2 - ACR Registry Name
# $3 - Azure Key Vault
#
RES_GROUP=$1 # Resource Group name
ACR_NAME=$2  # Azure Container Registry registry name
AKV_NAME=$3  # Azure Key Vault vault name

az keyvault create -g $RES_GROUP -n $AKV_NAME

# Create service principal, store its password in AKV (the registry *password*)
az keyvault secret set \
  --vault-name $AKV_NAME \
  --name $ACR_NAME-pull-pwd \
  --value $(az ad sp create-for-rbac \
                --name http://$ACR_NAME-pull \
                --scopes $(az acr show --name $ACR_NAME --query id --output tsv) \
                --role acrpull \
                --query password \
                --output tsv)

# Store service principal ID in AKV (the registry *username*)
az keyvault secret set \
    --vault-name $AKV_NAME \
    --name $ACR_NAME-pull-usr \
    --value $(az ad sp show --id http://$ACR_NAME-pull --query appId --output tsv)


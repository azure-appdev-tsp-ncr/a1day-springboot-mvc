#!/bin/sh
# Create Azure Keyvault and Support Azure Container Registry Secrets
# Parameters:
# $1 - Resource Group to use for Key Vault
# $2 - ACR Registry Name
# $3 - ACR product-catalog repo Tag
# $4 - Azure Key Vault Name
#
RES_GROUP=$1                    # Resource Group name
ACR_NAME=$2                     # Azure Container Registry Name
ACR_LOGIN_SERVER=$2.azurecr.io  # Azure Container Registry Login Server
ACR_IMAGE_TAG=$3                # Product Catalog Image Tag
AKV_NAME=$4                     # Azure Key Vault vault name

az container create \
    --name aci-catalog-demo-$ACR_IMAGE_TAG \
    --resource-group $RES_GROUP \
    --image $ACR_LOGIN_SERVER/product-catalog:$ACR_IMAGE_TAG \
    --registry-login-server $ACR_LOGIN_SERVER \
    --registry-username $(az keyvault secret show --vault-name $AKV_NAME -n $ACR_NAME-pull-usr --query value -o tsv) \
    --registry-password $(az keyvault secret show --vault-name $AKV_NAME -n $ACR_NAME-pull-pwd --query value -o tsv) \
    --dns-name-label ghtsp-aci-catalog-demo-$ACR_IMAGE_TAG \
    --ports 8080 \
    --query ipAddress.fqdn

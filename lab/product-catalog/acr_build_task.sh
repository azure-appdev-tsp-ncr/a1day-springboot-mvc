#!/bin/sh
#
# Script to create ACR Build Task for Product Catalog Container
# Parameters used:
# $1 - Git User ID 
# $2 - Git Access Token
# $3 - ACR Name
#
export GIT_USER=$1
export GIT_PAT=$2
export ACR_NAME=$3
# Create ACR Build Task, will be triggerd by Git push on source repo
az acr build-task create \
  --registry $ACR_NAME \
  --name buildProdCatalog \
  --image product-catalog:{{.Build.ID}} \
  --context https://github.com/azure-appdev-tsp-ncr/a1day-springboot-mvc \
  --file ./lab/azure/Dockerfile \
  --branch master \
  --git-access-token $GIT_PAT

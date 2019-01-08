#!/bin/sh
# Create Product Catalog AKS Deployment in Target Namespace in existing AKS Instance
# Parameters:
# $1 - ACR Registry Name
# $2 - ACR product-catalog repo Tag
# $3 - Azure Key Vault Name
#
ACR_NAME=$1                     # Azure Container Registry Name
ACR_LOGIN_SERVER=$1.azurecr.io  # Azure Container Registry Login Server
ACR_IMAGE_TAG=$2                # Product Catalog Image Tag
AKV_NAME=$3                     # Azure Key Vault vault name
AKS_NAMESPACE=$4                # Azure Kubernetes Service Target Namespace
#
ACR_PULL_USR=$(az keyvault secret show --vault-name $AKV_NAME -n $ACR_NAME-pull-usr --query value -o tsv)
ACR_PULL_PWD=$(az keyvault secret show --vault-name $AKV_NAME -n $ACR_NAME-pull-pwd --query value -o tsv)
#echo ACR USR:$ACR_PULL_USR
#echo ACR PWD:$ACR_PULL_PWD
#exit
# Create Namespace
echo "--- Creating K8S Namespace: " $AKS_NAMESPACE
kubectl create namespace $AKS_NAMESPACE

# Create K8S Secret for ACR Access
echo "--- Creating ACR Pull Secret"
kubectl create secret docker-registry acr-secret \
--docker-server=$ACR_LOGIN_SERVER \
--docker-username=$ACR_PULL_USR \
--docker-password=$ACR_PULL_PWD \
--docker-email=aks@k8s.com \
--namespace=$AKS_NAMESPACE
#
# kubectl deployment using sed replace of registry/tag in deployment yaml
echo "--- Creating Product Catalog Deployment"
sed -e $(echo "s/myregistry/$ACR_NAME/g;s/latest/$ACR_IMAGE_TAG/g") ./product-catalog.yaml | kubectl apply -f - --namespace=$AKS_NAMESPACE



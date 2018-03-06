# bash script to execute az aks command to create aks cluster
#
# Assumes az login already performed, and an existing resource group has been created
# Additionally, location specified should be the same as resource group
#
#  $1 - Resource Group Name
#  $2 - Resource Group location (e.g eastus)

echo "###### Creating AKS Cluster $1-aks-cluster01 in Region: $1 and Location: $2
az aks create -n $1-aks-cluster01 -g $1 -c 2 -k 1.7.7 --generate-ssh-keys -l $2

echo "###### Generating Kubernetes Configuration Files
az aks get-credentials -n $1-aks-cluster01 -g $1

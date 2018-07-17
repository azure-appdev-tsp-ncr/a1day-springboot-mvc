# Deploy the Product Catalog Springboo App to AKS

* In Azure Cloud Shell use ACR Build + **kubectl** to deploy the Springboot Fat JAR to AKS

## Create Azure Container Registry (ACR) & ACR Build to push Docker Image to private ACR Repo

* From the Azure Cloud bash Shell
  ```
  git clone https://github.com/azure-appdev-tsp-ncr/a1day-springboot-mvc.git
  cd ./a1day-springboot-mvc/lab/product-catalog
  ```
* Build/Package the Product Catalog Application
    ```
    mvn clean package 
    ```
* Create Azure Container Registry (ACR) using Resouce Group/Location from GBC-Container Lab
   ```
   ACR_NAME=<registry-name>
   RES_GROUP=<resource-group>

   az acr create --resource-group $RES_GROUP --name $ACR_NAME --sku Standard --location eastus 
   ```

* Create ACR Build Task
  ```
  GIT_USER=ghoelzer-rht
  GIT_PAT=a82af0acea36dfa94fe3bb41d462a6dd17de70d8

  az acr build-task create \
    --registry $ACR_NAME \
    --name buildProdCatalog \
    --image product-catalog:{{.Build.ID}} \
    --context https://github.com/azure-appdev-tsp-ncr/a1day-springboot-mvc \
    --file ./lab/product-catalog/Dockerfile \
    --branch master \
    --git-access-token $GIT_PAT
  ```

* Manually Trigger the ACR Build Task
  ```
  az acr build-task run --registry $ACR_NAME --name buildProdCatalog
  ```

## Deploy database container to AKS

* Use the kubectl CLI to deploy each app
    ```
    cd ~/gbc-containers/labs/helper-files

    kubectl apply -f heroes-db.yaml
    ```

* Get mongodb pod name and set **MONGO_POD** environment variable
    ```
    kubectl get pods

    NAME                                 READY     STATUS    RESTARTS   AGE
    heroes-db-deploy-2357291595-k7wjk    1/1       Running   0          3m

    MONGO_POD=heroes-db-deploy-2357291595-k7wjk
    ```

* Import data into MongoDB using script

    Ensure the **MONGO_POD** environment variable is set to your pod name, and then once you exec into pod run the **import.sh** script
    ```
    kubectl exec -it $MONGO_POD bash

    root@heroes-db-deploy-2357291595-xb4xm:/# ./import.sh

    2018-01-16T21:38:44.819+0000	connected to: localhost
    2018-01-16T21:38:44.918+0000	imported 4 documents
    2018-01-16T21:38:44.927+0000	connected to: localhost
    2018-01-16T21:38:45.031+0000	imported 72 documents
    2018-01-16T21:38:45.040+0000	connected to: localhost
    2018-01-16T21:38:45.152+0000	imported 2 documents
    
    root@heroes-db-deploy-2357291595-xb4xm:/# exit
    ```
    **Note:  be sure to exit pod as shown above**
    

## Deploy the web and api containers to AKS

* Use the kubectl CLI to deploy each app

    ```
    cd ~/gbc-containers/labs/helper-files

    kubectl apply -f heroes-web-api.yaml
    ```

## Validate

* Check to see if pods are running in your cluster
    ```
    kubectl get pods

    NAME                                 READY     STATUS    RESTARTS   AGE
    heroes-api-deploy-1140957751-2z16s   1/1       Running   0          2m
    heroes-db-deploy-2357291595-k7wjk    1/1       Running   0          3m
    heroes-web-1645635641-pfzf9          1/1       Running   0          2m
    ```

* Check to see if services are deployed.
    ```
    kubectl get service

    NAME         TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)          AGE
    api          LoadBalancer   10.0.20.156   52.176.104.50    3000:31416/TCP   5m
    kubernetes   ClusterIP      10.0.0.1      <none>           443/TCP          12m
    mongodb      ClusterIP      10.0.5.133    <none>           27017/TCP        5m
    web          LoadBalancer   10.0.54.206   52.165.235.114   8080:32404/TCP   5m
    ```

* Browse to the External IP for your web application (on port 8080) and try the app

> The public IP can take a few minutes to create with a new cluster. Sit back and relax. Maybe check Facebook :-)

--------
### Scratch Pad for commands being tested with for potential inclusion in Lab

**Commands to run to re-build app with PostgreSQL support**
```
mvn clean package -Ppostgresql -DskipTests
docker run -it -p 8080:8080 -e JAVA_OPT="-Dspring.profiles.active=postgresql" springio/produ
ct-catalog:latest
```
github automated access:

a82af0acea36dfa94fe3bb41d462a6dd17de70d8

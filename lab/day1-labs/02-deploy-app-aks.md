# Deploy the Product Catalog Springboot App to AKS

* In Azure Cloud Shell use **ACR Build + kubectl** to deploy the Springboot Fat JAR to AKS

## Create Azure Container Registry (ACR) & ACR Build to push Docker Image to private ACR Repo

* From the Azure Cloud bash Shell
  ```
  git clone https://github.com/azure-appdev-tsp-ncr/a1day-springboot-mvc.git
  cd ./a1day-springboot-mvc/lab/product-catalog
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
  GIT_PAT=920d9b2edb0e560742ffdb8bbb65ae69e261559c

  az acr build-task create \
    --registry $ACR_NAME \
    --name buildProdCatalog \
    --image product-catalog:{{.Build.ID}} \
    --context https://github.com/azure-appdev-tsp-ncr/a1day-springboot-mvc \
    --file ./lab/azure/Dockerfile \
    --branch master \
    --git-access-token $GIT_PAT
  ```

* Manually Trigger the ACR Build Task
  ```
  az acr build-task run --registry $ACR_NAME --name buildProdCatalog
  ```

* Demo Automated Build with created Webhook
  ```
  # Git repo code will be changed/committed
 
  # Stream the Build Logs
  az acr build-task logs --registry $ACR_NAME

  # List Registry Builds
  az acr build-task list-builds --registry $ACR_NAME --output table
  ```
## Deploy product-catalog container to AKS

* Use kubectl CLI to create ACR Secret (Enable Admin User for your ACR from Azure Portal)
  ```
  kubectl create secret docker-registry acr-secret --docker-server=<Login Server> --docker-username=<Username> --docker-password=<Password> --docker-email=superman@heroes.com
  ```
* Use the kubectl CLI to deploy app
    ```
    cd ../helper-files

    kubectl apply -f product-catalog.yaml
    ```

* Get product-catalog pod name and check the logs
    ```
    kubectl get pods

    NAME                                 READY     STATUS    RESTARTS   AGE
    product-web-deploy-bcdb987cd-9r9sq    1/1       Running   0          3m

    kubectl logs -f product-web-deploy-bcdb987cd-9r9sq
    ```


* Check to see if services are deployed.
    ```
    kubectl get services
    
    NAME         TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)          AGE
    kubernetes   ClusterIP      10.0.0.1      <none>           443/TCP          34d
    web          LoadBalancer   10.0.67.150   168.62.189.204   8080:31540/TCP   25m
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

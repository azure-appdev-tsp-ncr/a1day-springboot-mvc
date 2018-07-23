# Local Docker/Java/Springboot Development & Unit Testing

## Build Local Springboot Application using Maven

1. from the Powershell or Windows CLI, clone the workshop repo into the local Workstation environment
    ```
    git clone https://github.com/azure-appdev-tsp-ncr/a1day-springboot-mvc.git
    ```

2. Change directories to the Application/Solution where the Maven pom.xml is located
    ```
    cd ./a1day-springboot-mvc/lab/product-catalog
    ```

3. Verify successful local Maven Build/Unit Test of the Product Catalog Application & Docker Image Build using Spotify/Docker Maven Plugin
    (Make sure your Docker Daemon Settings are updated to expose docker endpoint **without TLS**)
    ```
    mvn clean package 

    docker build --rm --no-cache -f Dockerfile -t product-catalog:latest .
    ```
4. Test your local Docker Application Image and Product Catalog Springboot Application
   ```
   docker run -it -p 8080:8080 product-catalog:latest
   ```
   Now open a browser to http://localhost:8080 and you should see something similar to the following Product Listing

   ![](../images/spring-lab-app1.png)

You should now have the Product Catalog Springboot MVC Application running in a Docker container locally on your workstation.  This solution utilizes the Spotify/Docker Maven Plugin, more details can be found here - https://github.com/spotify/dockerfile-maven

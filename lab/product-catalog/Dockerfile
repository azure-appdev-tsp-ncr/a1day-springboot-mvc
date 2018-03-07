FROM maven:3.5-jdk-8 as BUILD

COPY . /usr/src/app
RUN mvn --batch-mode -f /usr/src/app/pom.xml clean package -Ddockerfile.skip -DskipTests

FROM openjdk:8-jdk
ENV PORT 8080
EXPOSE 8080
COPY --from=BUILD /usr/src/app/target/product-catalog.jar /opt/app.jar
WORKDIR /opt
CMD ["java", "-jar", "app.jar"]

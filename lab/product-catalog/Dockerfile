FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
ENV JAVA_OPT="-Dspring.profiles.active=local"
COPY target/product-catalog.jar /product-catalog.jar
ENTRYPOINT java -Djava.security.egd=file:/dev/./urandom ${JAVA_OPT} -jar /product-catalog.jar 
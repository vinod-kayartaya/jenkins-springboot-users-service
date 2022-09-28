FROM amazoncorretto:17-alpine3.13
WORKDIR /vinod/workspace
COPY target/users-service-0.0.1-SNAPSHOT.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
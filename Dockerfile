# Base image with OpenJDK 17
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# The JAR will be specified dynamically via build args
ARG JAR_FILE
COPY ${JAR_FILE} app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

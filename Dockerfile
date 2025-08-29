# ---------- Stage 1: Runtime only ----------
FROM eclipse-temurin:21-jre-jammy

# Set working directory inside the container
WORKDIR /app

# Copy the JAR file from Jenkins workspace into the container
# (Assume Jenkins will place the JAR in target/ folder)
COPY target/BankingApp-0.0.1-SNAPSHOT.jar app.jar

# Expose the port Spring Boot runs on
EXPOSE 8080

# Run the Spring Boot JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

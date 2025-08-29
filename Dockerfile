FROM amazoncorretto:11-al2023-jdk
WORKDIR /app
COPY target/BankingApp-0.0.1-SNAPSHOT*.jar BankingApp-0.0.1-SNAPSHOT.jar 
CMD ["java","-jar","BankingApp-0.0.1-SNAPSHOT.jar"]
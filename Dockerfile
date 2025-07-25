# Use a base image with Java 17 or your preferred version
FROM eclipse-temurin:17-jdk-alpine

# Create a directory for the app
WORKDIR /app

# Copy the jar file into the container (update with your jar file name)
COPY target/*.jar app.jar

# Expose the port your app runs on (default is 8080)
EXPOSE 8080

# Command to run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]

# Stage 1: Build the application
# We use a JDK image here as it contains Maven and the necessary tools to compile
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files (pom.xml first for caching efficiency)
# This allows Docker to cache this layer if only src changes, not pom.xml
COPY pom.xml .
COPY src ./src

# Build the Spring Boot application using Maven Wrapper
# -Dmaven.test.skip=true is commonly used in CI/CD to skip tests during the image build
# if tests are run in a separate step or not desired in the final image.
# You can remove it if you want tests to run during the Docker build.
RUN ./mvnw clean package -Dmaven.test.skip=true

# Stage 2: Create the final, smaller runtime image
# We switch to a JRE image here because we only need to *run* the app, not build it,
# making the final image significantly smaller.
FROM eclipse-temurin:17-jre-alpine

# Set the working directory for the final application
WORKDIR /app

# Copy the built JAR file from the 'builder' stage into the final image
# The name of your jar file might be different (e.g., PortFolioBackend-0.0.1-SNAPSHOT.jar)
# The `*.jar` wildcard is generally robust, or you can specify the exact name
# from your pom.xml's <artifactId>-<version>.jar
COPY --from=builder /app/target/*.jar app.jar

# Expose the port your Spring Boot app listens on (default is 8080)
EXPOSE 8080

# Command to run your Spring Boot application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
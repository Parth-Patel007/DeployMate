# -------- Build Stage --------
FROM gradle:8.4.0-jdk17 AS build
WORKDIR /app

# Copy build config first (for better Docker layer caching)
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
RUN gradle build --no-daemon || return 0

# Now copy the full project and build the app
COPY . .
RUN gradle build --no-daemon

# -------- Runtime Stage --------
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy only the final JAR from the previous stage
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# Stage 1: Build executable WAR with Maven
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN apk add --no-cache curl unzip && chmod +x mvnw

COPY src/ src/
RUN ./mvnw -B clean package -DskipTests

# Stage 2: Minimal JRE runtime with non-root user
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=build --chown=appuser:appgroup /workspace/target/techcommerce.war /app/techcommerce.war

USER appuser
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8080/health-jsp > /dev/null || exit 1

ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-jar", "/app/techcommerce.war"]

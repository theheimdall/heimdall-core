FROM eclipse-temurin:17.0.4_8-jdk-alpine as builder
WORKDIR workspace
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM eclipse-temurin:17.0.4_8-jdk-alpine as runner
WORKDIR workspace
COPY --from=builder workspace/dependencies/ ./
COPY --from=builder workspace/snapshot-dependencies/ ./
COPY --from=builder workspace/spring-boot-loader/ ./
COPY --from=builder workspace/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]

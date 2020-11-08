FROM openjdk:11.0.8-buster

WORKDIR /orders-service

#COPY . /orders-service

RUN apt update
RUN apt install maven -y

#RUN mvn clean install

#ARG SERVICE_PORT
#CMD java -jar -Dserver.port=${SERVICE_PORT} target/*.jar
#CMD mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=${SERVICE_PORT}
CMD mvn spring-boot:run

# EXPOSE 8080
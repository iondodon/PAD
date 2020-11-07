FROM openjdk:11.0.8-buster

WORKDIR /orders-service

#COPY . /orders-service

RUN apt update
RUN apt install maven -y

#RUN mvn clean install
#CMD java -jar -Dserver.port=8080 target/*.jar

ARG SERVICE_PORT=${SERVICE_PORT}
CMD mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=${SERVICE_PORT}

EXPOSE 8080-8090
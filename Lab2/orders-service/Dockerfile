FROM openjdk:11.0.8-buster

WORKDIR /orders-service

#COPY . /orders-service

RUN apt update
RUN apt install maven -y

#RUN mvn clean install
#CMD java -jar -Dserver.port=8080 target/*.jar
#CMD mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8085

EXPOSE 8080-8090
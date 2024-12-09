FROM maven:3.8.4-openjdk-11-slim 

WORKDIR /app

COPY target/*.jar /app.jar

EXPOSE 8080

CMD java -jar /app.jar $APP_ARGS
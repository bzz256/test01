ARG DOCKERHUB=docker.io
FROM ${DOCKERHUB}/openjdk:11-jdk AS builder

RUN mkdir /buildplace && chmod a+rwx /buildplace
WORKDIR /buildplace
COPY ./.mvn ./.mvn/
COPY ./mvnw ./
RUN chmod a+x ./mvnw && ./mvnw -v

COPY ./pom.xml ./
RUN ./mvnw dependency:resolve

COPY . ./
RUN chmod a+x ./mvnw && ./mvnw package

ARG DOCKERHUB=docker.io
FROM ${DOCKERHUB}/openjdk:11-jdk

RUN mkdir /workplace && chmod a+rwx /workplace
WORKDIR /workplace
COPY --from=builder /buildplace/target/creatives-0.0.1-SNAPSHOT.jar /workplace/application.jar
RUN chmod a+rwx /workplace/application.jar
ENV JAVA_OPTS=
CMD exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /workplace/application.jar

EXPOSE 8080

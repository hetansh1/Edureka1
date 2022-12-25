FROM maven:3.6.1-jdk-8 as maven_builder

WORKDIR /app

ADD pom.xml .

RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]

ADD . .

RUN ["mvn","clean","install","package","-T","2C","-DskipTests=true"]

ADD . /app

#FROM tomcat:9.0.70-jdk8

#COPY --from=maven_builder target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/
FROM tomcat

COPY --from=maven_builder /app/target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps

EXPOSE 8008

CMD ["catalina.sh", "run"]

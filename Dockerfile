FROM tomcat:alpine
COPY ./target/hello-1.0.war /usr/local/tomcat/webapps
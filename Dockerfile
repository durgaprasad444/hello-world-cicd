# Pull base image
FROM tomcat:8-jre8

# Maintainer
MAINTAINER "xxx <xxx@gmail.com">

# Copy to images tomcat path
ADD ./target/*.war  /usr/local/tomcat/webapps/

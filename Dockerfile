# Gatling is a highly capable load testing tool.
#
# Documentation: http://gatling.io/docs/2.2.2/
# Cheat sheet: http://gatling.io/#/cheat-sheet/2.2.2

FROM java:8-jdk-alpine

MAINTAINER Denis Vazhenin

# working directory for gatling
WORKDIR /opt

RUN apk add --update wget 

# gating version
ENV GATLING_VERSION 2.2.2


# install gatling
RUN adduser -D -s /bin/bash jenkins

RUN chown -R jenkins:jenkins /opt 
RUN chown -R jenkins:jenkins /tmp

USER jenkins

# create directory for gatling install
RUN mkdir -p gatling
RUN mkdir -p gatling/results

  RUN mkdir -p /tmp/downloads && \
  wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
  https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
  mkdir -p /tmp/archive && cd /tmp/archive && \
  unzip /tmp/downloads/gatling-$GATLING_VERSION.zip && \
  mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/

# change context to gatling directory
WORKDIR  /opt/gatling

# set directories below to be mountable from host
VOLUME ["/opt/gatling/conf", "/opt/gatling/results", "/opt/gatling/user-files"]

# set environment variables
ENV PATH /opt/gatling/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GATLING_HOME /opt/gatling



ENTRYPOINT ["gatling.sh"]
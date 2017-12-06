FROM docker.elastic.co/beats/filebeat:5.6.2

MAINTAINER james.hn.sears@gmail.com

COPY filebeat.yml /usr/share/filebeat/filebeat.yml

USER root

RUN mkdir -p /opt/apache-activemq-5.15.0/data
RUN chown filebeat:filebeat /opt/apache-activemq-5.15.0/data

RUN chown filebeat:filebeat /usr/share/filebeat/filebeat.yml

USER filebeat

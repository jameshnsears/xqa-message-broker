FROM debian:latest

MAINTAINER james.hn.sears@gmail.com

RUN apt-get -qq update
RUN apt-get -qq install curl

ARG INSTALLDIR=/opt/
ARG VERSION=5.15.2
ARG ACTIVEMQ=apache-activemq-${VERSION}

RUN curl https://archive.apache.org/dist/activemq/${VERSION}/${ACTIVEMQ}-bin.tar.gz -o ${INSTALLDIR}/${ACTIVEMQ}-bin.tar.gz
RUN tar -xzf ${INSTALLDIR}${ACTIVEMQ}-bin.tar.gz -C ${INSTALLDIR}

RUN sed -i 's/log4j.rootLogger=INFO, console, logfile/log4j.rootLogger=INFO, logfile/' ${INSTALLDIR}${ACTIVEMQ}/conf/log4j.properties
RUN sed -i 's/#ACTIVEMQ_OPTS=\"$ACTIVEMQ_OPTS -Dorg.apache.activemq.audit=true\"/ACTIVEMQ_OPTS=\"$ACTIVEMQ_OPTS -Dorg.apache.activemq.audit=true\"/' ${INSTALLDIR}${ACTIVEMQ}/bin/env
RUN sed -i 's/createConnector=\"false\"/createConnector=\"true\"/' ${INSTALLDIR}${ACTIVEMQ}/conf/activemq.xml
RUN apt-get -qq install -y openjdk-8-jre
RUN useradd -r -M -d ${INSTALLDIR}${ACTIVEMQ} activemq
RUN chown -R activemq:activemq ${INSTALLDIR}${ACTIVEMQ}

USER activemq

WORKDIR ${INSTALLDIR}${ACTIVEMQ}

EXPOSE 1099 5672 8161 61616

CMD ["/bin/sh", "-c", "bin/activemq console"]

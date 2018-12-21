FROM ubuntu:bionic

RUN apt-get -qq update
RUN apt-get -qq install curl

RUN apt-get install --reinstall -y locales
RUN sed -i 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB
ENV LC_ALL en_GB.UTF-8
RUN dpkg-reconfigure --frontend noninteractive locales

ARG INSTALLDIR=/opt/
ARG VERSION=5.15.7
ARG ACTIVEMQ=apache-activemq-${VERSION}

RUN curl https://archive.apache.org/dist/activemq/${VERSION}/${ACTIVEMQ}-bin.tar.gz -o ${INSTALLDIR}/${ACTIVEMQ}-bin.tar.gz
RUN tar -xzf ${INSTALLDIR}${ACTIVEMQ}-bin.tar.gz -C ${INSTALLDIR}

RUN sed -i 's/log4j.rootLogger=INFO, console, logfile/log4j.rootLogger=INFO, logfile/' ${INSTALLDIR}${ACTIVEMQ}/conf/log4j.properties
RUN sed -i 's/#ACTIVEMQ_OPTS=\"$ACTIVEMQ_OPTS -Dorg.apache.activemq.audit=true\"/ACTIVEMQ_OPTS=\"$ACTIVEMQ_OPTS -Dorg.apache.activemq.audit=true\"/' ${INSTALLDIR}${ACTIVEMQ}/bin/env
RUN sed -i 's/createConnector=\"false\"/createConnector=\"true\"/' ${INSTALLDIR}${ACTIVEMQ}/conf/activemq.xml
RUN apt-get -qq install -y openjdk-11-jre
RUN useradd -r -M -d ${INSTALLDIR}${ACTIVEMQ} activemq
RUN chown -R activemq:activemq ${INSTALLDIR}${ACTIVEMQ}

USER activemq

WORKDIR ${INSTALLDIR}${ACTIVEMQ}

EXPOSE 1099 5672 8161 61616

CMD ["/bin/sh", "-c", "bin/activemq console"]

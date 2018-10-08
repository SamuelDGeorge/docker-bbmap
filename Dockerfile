FROM ubuntu:16.04
LABEL MAINTAINER Michael Laccetti <michael@laccetti.com> <https://laccetti.com/)
LABEL Additional tools add by Samuel George <sdgeorge@hub.docker.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8
ENV PATH "$PATH:/bbmap"

COPY BBMap_38.26.tar.gz /BBMAP_38.26.tar.gz
COPY samtools-1.9.tar.bz2 /samtools-1.9.tar.bz2


RUN apt-get update && \
  apt-get install -y bzip2 && \
  tar -xvzf BBMAP_38.26.tar.gz && \
  rm BBMAP_38.26.tar.gz && \
  bzip2 -d samtools-1.9.tar.bz2 && \
  tar -xvf samtools-1.9.tar && \
  rm samtools-1.9.tar
RUN apt-get update && \
  apt-get install -y --no-install-recommends locales && \
  locale-gen en_US.UTF-8 && \
  apt-get dist-upgrade -y && \
  apt-get --purge remove openjdk* && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default && \
  apt-get install -y build-essential && \
  apt-get install -y libncurses5-dev && \
  apt-get install -y zlib1g-dev && \
  apt-get install -y libbz2-dev && \
  apt-get install -y liblzma-dev && \
  cd samtools-1.9 && \
  ./configure && \
  make && \
  make install && \
  make clean && \
  apt-get purge -y build-essential && \
  apt-get update && \
  apt-get clean all 
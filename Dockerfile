FROM debian:jessie
#FROM avastsoftware/perl_critic:latest

#RUN yum -y install bash ca-certificates coreutils jq git wget
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git unzip wget jq

ENV REVIEWDOG_VERSION=v0.10.0
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

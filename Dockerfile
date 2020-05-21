FROM avastsoftware/perl_critic:latest

RUN yum -y install bash ca-certificates coreutils jq git

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

ENV REVIEWDOG_VERSION=v0.10.0
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/bin/ ${REVIEWDOG_VERSION}

ENTRYPOINT ["/entrypoint.sh"]

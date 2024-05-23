FROM neomediatech/ubuntu-base:22.04

ENV APP_VERSION=N/A \
    SERVICE=update-ipsets

LABEL maintainer="docker-dario@neomediatech.it" \
      org.label-schema.version=$APP_VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE \
      org.label-schema.maintainer=Neomediatech

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install --no-install-recommends --no-install-suggests -y ca-certificates unzip curl procps ipset jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists*

COPY --chmod=777 bin/update-ipsets /usr/bin
COPY --chmod=777 bin/iprange /usr/bin
COPY --chmod=777 bin/entrypoint.sh /
COPY --chmod=777 bin/start.sh /
COPY bin/install.config /usr/bin
COPY bin/functions.common /usr/bin
COPY conf/update-ipsets.conf /etc/firehol/update-ipsets.conf

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["/tini","--","update-ipsets","-s"]
CMD ["/tini","--","/start.sh"]


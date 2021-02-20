FROM ubuntu:focal

RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -q -y sudo && \
rm -rf /var/lib/apt/lists/* 

COPY emacsclient /usr/local/bin/
COPY emacsclient_wrapper.sh /usr/local/bin/
COPY bootstrap.sh /usr/local/sbin/

ENTRYPOINT [ "/usr/local/sbin/bootstrap.sh" ]

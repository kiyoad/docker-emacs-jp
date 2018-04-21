FROM ubuntu:xenial

ARG INSTALL_USER=developer
ARG UID=1000

RUN \
  adduser --disabled-password --gecos "Developer" --uid "${UID}" "${INSTALL_USER}" && \
  chown -R "${INSTALL_USER}":"${INSTALL_USER}" "/home/${INSTALL_USER}"

COPY emacsclient /usr/local/bin/emacsclient
COPY startup.sh /usr/local/bin/startup.sh

USER ${INSTALL_USER}
RUN mkdir "/tmp/emacs${UID}" && chmod 0700 "/tmp/emacs${UID}"

WORKDIR /home/${INSTALL_USER}
ENTRYPOINT [ "/usr/local/bin/startup.sh" ]

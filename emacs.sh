#!/bin/bash
set -eu
emacs_socket="/tmp/emacs$(id -u)"
mkdir -p "${emacs_socket}"
chmod 0700 "${emacs_socket}"
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v "${emacs_socket}:${emacs_socket}" -v "${HOME}:/home/${LOGNAME}" --detach-keys="ctrl-u,ctrl-q" kiyoad/emacs "${LOGNAME}" "$(id -u)" "$@"

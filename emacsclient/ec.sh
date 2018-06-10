#!/bin/bash
set -eu
emacs_socket="/tmp/emacs$(id -u)"
mkdir -p "${emacs_socket}"
chmod 0700 "${emacs_socket}"
docker run --rm -it -v "${emacs_socket}:${emacs_socket}" -v "${HOME}:/home/${LOGNAME}" kiyoad/emacsclient "${LOGNAME}" "$(id -u)" "$(pwd)" "$@"

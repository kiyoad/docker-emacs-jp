#!/bin/bash
set -euo pipefail
emacs_socket="/tmp/emacs$(id -u)"
mkdir -p "${emacs_socket}"
chmod 0700 "${emacs_socket}"
docker run --rm -d -v "${emacs_socket}:${emacs_socket}" -v /dev/shm:/dev/shm -v /tmp/.X11-unix:/tmp/.X11-unix -v "${HOME}:/home/${LOGNAME}" --name emacs --hostname emacs kiyoad/emacs "gui" "${LOGNAME}" "${LOGNAME}" "$(id -u)" "$@"

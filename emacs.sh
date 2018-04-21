#!/bin/bash
set -euo pipefail
socketfilepath="/tmp/emacs$(id -u)"
mkdir -p "${socketfilepath}"
chmod 0700 "${socketfilepath}"
docker run --rm -it -v "${socketfilepath}:${socketfilepath}" -v "${HOME}:/home/${LOGNAME}" --detach-keys="ctrl-u,ctrl-q" kiyoad/emacs "$@"

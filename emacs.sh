#!/bin/bash
set -euo pipefail
docker run --rm -it -v ${HOME}:/home/${LOGNAME} --detach-keys="ctrl-q,ctrl-p" kiyoad/emacs $*

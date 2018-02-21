#!/bin/bash
set -euo pipefail
docker run --rm -it -v ${HOME}:/home/${LOGNAME} kiyoad/emacs $*

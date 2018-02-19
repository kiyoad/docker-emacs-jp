#!/bin/bash
set -euo pipefail
docker run --rm -it -v ${HOME}:/home/developer kiyoad/emacs $*

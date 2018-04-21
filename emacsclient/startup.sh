#!/bin/bash
set -euo pipefail
cwd=$1
shift
cd "${cwd}"
emacsclient "$@"

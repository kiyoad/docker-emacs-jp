#!/bin/bash
set -eu
cwd=$1
shift
cd "${cwd}"
emacsclient "$@"

#!/bin/bash
set -euo pipefail
read -rp "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
docker stop emacs

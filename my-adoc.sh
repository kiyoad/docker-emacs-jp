#!/bin/bash
set -eu
asciidoctor -r asciidoctor-diagram "$@"

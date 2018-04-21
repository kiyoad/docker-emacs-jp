#!/bin/bash
set -eu
asciidoctor-pdf -r asciidoctor-pdf-cjk -r asciidoctor-diagram "$@"

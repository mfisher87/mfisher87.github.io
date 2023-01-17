#!/usr/bin/env bash
args="$@"

docker run --rm -it \
  -v ${PWD}:/src \
  -p 1313:1313 \
  klakegg/hugo:0.107.0 \
  server --buildDrafts $args

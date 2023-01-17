#!/usr/bin/env bash
args="$@"

docker run --rm -it \
  -v ${PWD}:/src \
  klakegg/hugo:0.107.0 \
  $args
rc="$?"

# HACK: Fix ownership. Docker is likely run as root, so new files will be owned
# by root.
if [ "${1}" = "new" ]; then
    sudo chown -R "${USER}:${USER}" ${PWD}
fi

exit $rc

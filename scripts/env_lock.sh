#!/usr/bin/env bash

ROOT_DIR="$(git rev-parse --show-toplevel)"

conda env export | grep -v "^prefix" > "${ROOT_DIR}/environment-lock.yml"

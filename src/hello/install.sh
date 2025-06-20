#!/usr/bin/env bash

set -e;

echo "Activating feature 'hello'"

install --owner=root --group=root --mode=755 -T hello /usr/local/bin/hello

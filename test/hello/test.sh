#!/usr/bin/env bash

set -e;

#-- This file comes from the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib;

check "Execute command" bash -c "hello | grep 'Hello, $(whoami)!'";

reportResults;

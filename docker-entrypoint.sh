#!/bin/bash
set -e

test -d /certs || mkdir /certs
cp /workspace/ca.crt /certs

exec "$@"

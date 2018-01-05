#!/bin/bash
#esrally configure
set -x
echo ${ES_ADDR}
#esrally race --offline --pipeline=benchmark-only --target-hosts=${ES_ADDR}

exec "$@"

#!/bin/bash

set -x
set -e
cd /opt/estack/lucene-solr
ant ivy-bootstrap
ant compile
if [ $? != 0 ]; then
  echo "build lucene solr failed"
  exit 1
fi
ant test
if [ $? != 0 ]; then
  echo "lucene unit test failed, continue build elasticsearch"
fi

cd solr
ant server
if [ $? != 0 ]; then
  echo "build lucene server failed"
fi

cd /opt/estack/elasticsearch
./gradlew clean assemble test
echo "elasticsearch build finished, logs are redirected."
ls -al /opt/build/logs/
exec "$@"

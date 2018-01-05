#!/bin/bash
apt-get update
apt-get install -y --no-install-recommends curl git ca-certificates
# dnsutils is not needed in production environment
apt-get install -y dnsutils inetutils-ping 
#gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s
source /usr/local/rvm/scripts/rvm
rvm install ruby-2.3.6
gem install redis

#!/bin/bash
apt-get remove -y git curl
apt-get autoremove -y
rm -rf /tmp/go1.9.3.linux-amd64.tar.gz
rm -rf /home/repo/src/

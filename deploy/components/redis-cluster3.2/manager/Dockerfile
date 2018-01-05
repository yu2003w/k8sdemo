# Written by Jared on Jan 23, 2018.
FROM redis:3.2

# install ruby and run 'gem install redis'
COPY sources.list /etc/apt/sources.list
COPY redis3.2.11/redis-trib.rb  /usr/local/bin/redis-trib.rb
COPY redis3.2.11/installGemRedis.sh /usr/local/bin/installGemRedis.sh
RUN chmod +x /usr/local/bin/installGemRedis.sh \
  && installGemRedis.sh \
  && chmod +x /usr/local/bin/redis-trib.rb \
  && rm -rf /var/lib/apt/lists/*

# install peer-finder
COPY redis3.2.11/go1.9.3.linux-amd64.tar.gz  /tmp/
COPY redis3.2.11/peer-finder.go   /tmp/
COPY redis3.2.11/clean.sh  /usr/local/bin/
RUN tar -xvf /tmp/go1.9.3.linux-amd64.tar.gz -C  /usr/local/ \
  && mkdir -p /home/repo/src/ \
  && cp /tmp/peer-finder.go /home/repo/src/ \
  && export GOPATH=/home/repo/  \
  && /usr/local/go/bin/go get k8s.io/apimachinery/pkg/util/sets \
  && cd /home/repo/src/ \
  && /usr/local/go/bin/go build /home/repo/src/peer-finder.go \
  && mv peer-finder /usr/local/bin/   \
  && chmod +x /usr/local/bin/clean.sh \
  && clean.sh

# added scripts for cluster setup and dynamically increase master/slave nodes
COPY redis3.2.11/cluster-meet.sh  /usr/local/bin/
RUN chmod +x /usr/local/bin/cluster-meet.sh


EXPOSE 16379
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]

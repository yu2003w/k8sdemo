# Written by Jared on Feb 27, 2018.
# Script to set configurations for elasticsearch.
set -x
# get ip address firstly
ip_addr=$(getent hosts $(hostname).es-cluster.brokers.svc.cluster.local | cut -d' ' -f1)


sed -i "s/NETWORKHOST/${ip_addr}/g" /usr/share/elasticsearch/config/elasticsearch.yml

sed -i "s/cluster-name/${CLUSTER_NAME}/g" /usr/share/elasticsearch/config/elasticsearch.yml

echo "discovery.zen.ping.unicast.hosts:" >> /usr/share/elasticsearch/config/elasticsearch.yml

# get current ordinal 
ordinal=$(hostname | cut -d'-' -f2)
ordinal=$(( $ordinal + 1))
i=0
if [ $ordinal -gt ${NODES_NUM} ]; then
  NODES_NUM=$ordinal
fi

while [ $i -lt ${NODES_NUM} ]
do
  echo "  - es-"${i}.es-cluster.brokers.svc.cluster.local >> /usr/share/elasticsearch/config/elasticsearch.yml 
  i=$(($i+1))
done


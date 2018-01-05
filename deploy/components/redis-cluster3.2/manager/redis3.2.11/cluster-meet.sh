#!/bin/bash

set -e
# set environment for ruby scripts execution
source /usr/local/rvm/scripts/rvm

# Port on which redis listens for connections.
PORT=6379
CLUSTER_IPS=""

ordinal_index=$(hostname | cut -d'-' -s -f2)

# Wait until local redis is available before proceeding
until redis-cli -h 127.0.0.1 ping; do sleep 1; done

echo $(hostname) "is ready" > /tmp/redis-cluster.log

if [[ ${ordinal_index} == 5 ]]; then
  echo $((${ordinal_index} + 1)) "redis instances are started, ready for creating cluster..."

  # Convert all peers to raw addresses
  while read -ra LINE; do
    CLUSTER_IPS="${CLUSTER_IPS} $(getent hosts ${LINE} | cut -d' ' -f1):${PORT}"
  done

  # redis-trib.rb should only run once, and should only call yes_or_die once
  # during init. Not wild about possible unintended confirmations...
  echo "Initialized redis cluster with IPs->" ${CLUSTER_IPS} >> /tmp/redis-cluster.log

  echo yes | /usr/local/bin/redis-trib.rb create --replicas 1 ${CLUSTER_IPS}

  echo "redis cluster setup successfully" >> /tmp/redis-cluster.log

  redis-cli -c -h 127.0.0.1 -p 6379 cluster nodes >> /tmp/redis-cluster.log

elif [[ ${ordinal_index} -gt 5 ]]; then

  echo "redis instance ${ordinal_index} started"
  ret=$((${ordinal_index} % 2))
  if [[ $ret == 0 ]]; then
    echo "added this instance as master node"

    # here, use redis-0 as the random cluster node
    /usr/local/bin/redis-trib.rb add-node $(getent hosts $(hostname) | cut -d' ' -f1):${PORT} $(getent hosts redis-0.redis-cluster.brokers.svc.cluster.local | cut -d' ' -f1):${PORT}

    if [ $? != 0 ]; then
      echo "Adding master node ${ordinal_index} failed"
    else
      echo "Adding master node ${ordinal_index} succeeded"
    fi
  else 
    echo "added this instance as slave node"

    /usr/local/bin/redis-trib.rb add-node --slave $(getent hosts $(hostname) | cut -d' ' -f1):${PORT} $(getent hosts redis-0.redis-cluster.brokers.svc.cluster.local | cut -d' ' -f1):${PORT}
    if [ $? != 0 ]; then
      echo "Adding slave node ${ordinal_index} failed"
    else
      echo "Adding slave node ${ordinal_index} succeeded"
    fi

    # after added new redis instances into cluster, need to reshard clusters to make newly added nodes to work
    # need to make this work automatically
    inst_num=$(((${ordinal_index} + 1)/2))
    ave_slot_num=$((16384/${inst_num}))
    echo "Totally ${inst_num} master instances, reshard cluster need to move ${ave_slot_num} slots" >> /tmp/redis-cluster.log
    
    # retrieve node id
    inst_ip=$(getent hosts redis-$((${ordinal_index}-1)).redis-cluster.brokers.svc.cluster.local | cut -d' ' -f1)
    node_id=$(redis-cli -c -h ${inst_ip} -p 6379 cluster nodes | grep myself | cut -d' ' -f1)
    echo "Newly added instance info: ${inst_ip} ${node_id}" >> /tmp/redis-cluster.log

    /usr/local/bin/redis-trib.rb reshard --from all --to ${node_id} --slots ${ave_slot_num} --yes $(getent hosts redis-0.redis-cluster.brokers.svc.cluster.local | cut -d' ' -f1):${PORT} 
  fi

  redis-cli -c -h 127.0.0.1 -p 6379 cluster nodes >> /tmp/redis-cluster.log
  
else
  echo "ordinal index->" ${ordinal_index}
  echo "redis-"${ordinal_index} "awaiting for more redis instances to be started" >> /tmp/redis-cluster.log
fi


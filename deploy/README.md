This repository contains deployments for k8s.

Initiated by Jared on Jan 5, 2018.

1, redis-cluster

   peer-finder is used for redis instance discovery. And master/slave configuration is 1-1 style.

   Statefulset is used as controller for this deployment.
 
   Auto scale up and resharding slots to new instance is supported.

   Note: Sometimes need to make container run as root, issue following command to enable that.

   oc adm policy add-scc-to-user anyuid system:serviceaccount:{project name}:default

   Note: need more investigation about above command

2, elasticsearch cluster

   Note: Sometimes need to customize kernel settings for container.

   However, it's a little difficult to do that inside container

   Another workaround is to customize kernerl settings on host, than the parameters could be passed to container.

   For example, added "vm.max_map_count = 262144" into /etc/sysctl.conf on host will make that take effect inside container.

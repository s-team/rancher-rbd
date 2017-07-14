#!/usr/bin/env bash
set -x

pid=0

POOLNAME="docker"

# SIGUSR1 -handler
my_handler() {
  echo "SIGUSR1"
}

# SIGTERM -handler
term_handler() {
  echo "SIGTERM"

  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM

#!/usr/bin/env bash

IMAGES_POOL=$(rbd ls $POOLNAME)
for d in $(find /sys/bus/rbd/devices -type l);
do
  n=${cat d/name}
  r="${IMAGES_POOL/n/}"
  IMAGES_POOL=$r
done

for i in $IMAGES_POOL;
do
  echo "mapping: " $i;
  #echo "172.25.25.100,172.25.25.101,172.25.25.102 name=admin,secret=AQDpsc9YAackCBAAD2z+Ih91XzJexNJnnBh0Dw== docker rancher-mariadb" > /sys/bus/rbd/add
  #echo "0" >/sys/bus/rbd/remove
  echo "172.25.25.100,172.25.25.101,172.25.25.102 name=admin,secret=AQDpsc9YAackCBAAD2z+Ih91XzJexNJnnBh0Dw== $POOLNAME $i" > /sys/bus/rbd/add
done

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done

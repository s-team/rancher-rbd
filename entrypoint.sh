#!/bin/bash

printf "[global]\nmon_host = $RBD_MONITOR_IPS\n" >/etc/ceph/ceph.conf
printf "[client.$RBD_USER_NAME]\n        key = $RBD_SECRET\n" >/etc/ceph/ceph.client.$RBD_USER_NAME.keyring

if [ -z "$1" ]; then
  /bin/bash
else
  $@
fi

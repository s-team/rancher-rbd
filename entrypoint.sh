#!/bin/bash

printf "[global]\nfsid = $RBD_FSID\nmon_host = $RBD_MONITOR_IPS\nauth_cluster_required = cephx\nauth_service_required = cephx\nauth_client_required = cephx\n\nmon_allow_pool_delete = true\n" >/etc/ceph/ceph.conf
printf "[client.$RBD_USER_NAME]\n        key = $RBD_SECRET\n" >/etc/ceph/ceph.client.$RBD_USER_NAME.keyring.conf

if [ -z "$1" ]; then
  /bin/bash
else
  $@
fi

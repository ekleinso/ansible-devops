#!/usr/bin/env bash

set -o errexit
set -o pipefail

# example
# etcd-snapshot-backup.sh $path-to-snapshot

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

usage () {
    echo 'Path to backup file required: ./etcd-snapshot-backup.sh ./backup.db'
    exit 1
}

ASSET_DIR=./assets

if [ "$1" != "" ]; then
  SNAPSHOT_FILE="$1"
else
  usage
fi

CONFIG_FILE_DIR=/etc/kubernetes
MANIFEST_DIR="${CONFIG_FILE_DIR}/manifests"
MANIFEST_STOPPED_DIR="${ASSET_DIR}/manifests-stopped"
ETCDCTL="/usr/bin/etcdctl"
ETCD_DATA_DIR=/var/lib/etcd
ETCD_MANIFEST="${MANIFEST_DIR}/etcd-member.yaml"
ETCD_STATIC_RESOURCES="${CONFIG_FILE_DIR}/static-pod-resources/etcd-member"
STOPPED_STATIC_PODS="${ASSET_DIR}/tmp/stopped-static-pods"

source "/usr/local/bin/openshift-recovery-tools"

function run {
  init
  backup_etcd_client_certs
  backup_manifest
  snapshot_data_dir
}

run

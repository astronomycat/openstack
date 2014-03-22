#!/bin/sh

source /root/keystone_rc

INT_NET_NAME="internal"
EXT_NET_NAME="external"

FLAVOR_ID=10
IMAGE_NAME="vyatta-lite"
VM_NAME=vyatta-gw-$1
AVA_ZONE=$2

echo vm_name=${VM_NAME}
echo availability-zone= ${AVA_ZONE}
NETWORK_ID_INT=`neutron net-list|grep ${INT_NET_NAME}|awk '{print $2}'`
NETWORK_ID_EXT=`neutron net-list|grep ${EXT_NET_NAME}|awk '{print $2}'`
IMAGE_ID=`glance image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
nova boot --availability-zone ${AVA_ZONE} --flavor ${FLAVOR_ID} --image ${IMAGE_ID} --nic net-id=${NETWORK_ID_EXT} --nic net-id=${NETWORK_ID_INT} ${VM_NAME}


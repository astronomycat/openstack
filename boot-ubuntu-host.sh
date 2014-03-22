#!/bin/sh

source /root/keystone_rc

INT_NET_NAME="internal"
FLAVOR_ID=1
IMAGE_NAME="ubuntu-lite"
VM_NAME=ubuntu-host-$1
AVA_ZONE=$2

echo vm_name=${VM_NAME}
echo availability-zone= ${AVA_ZONE}
NETWORK_ID=`neutron net-list|grep ${INT_NET_NAME}|awk '{print $2}'`
IMAGE_ID=`glance image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
nova boot --availability-zone ${AVA_ZONE} --flavor ${FLAVOR_ID} --image ${IMAGE_ID} --nic net-id=${NETWORK_ID} ${VM_NAME}


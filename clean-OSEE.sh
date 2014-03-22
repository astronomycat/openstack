#!/bin/sh

#Those variables can be customized.
INT_NET_NAME="network1"
INT_SUBNET_NAME="subnet1"
ROUTER_NAME="router1"

echo Cleanup the original OSEE stuffs...
echo Removing the router added
SUBNET_ID=`neutron subnet-list|grep ${INT_SUBNET_NAME}|awk '{print $2}'`
echo SUBNET_ID=${SUBNET_ID}

ROUTER_ID=`neutron router-list|grep ${ROUTER_NAME}|awk '{print $2}'`
echo ROUTER_ID=${ROUTER_ID}

neutron router-interface-delete ${ROUTER_ID} ${SUBNET_ID}
neutron router-delete ${ROUTER_ID}


echo
echo Removing the internal net added

neutron net-delete ${INT_NET_NAME}
#neutron subnet-create --tenant-id ${TENANT_ID} --name ${INT_SUBNET_NAME} ${INT_NET_NAME} ${INT_IP_CIDR} --dns_nameservers list=true 8.8.8.7 8.8.8.8


neutron net-list --all-tenant
neutron port-list --all-tenant
neutron router-list --all-tenant

exit

#!/bin/sh
#Create a project and add a new user with net/subnet/vm image...

#Those variables can be customized.
TENANT_NAME="vyatta"
USER_NAME="vyatta"
USER_PWD="303034"
INT_NET_NAME="internal"
INT_SUBNET_NAME="subnet_int"
EXT_NET_NAME="external"
EXT_SUBNET_NAME="subnet_ext"
ROUTER_NAME="vRouter"
IMAGE_NAME="vyatta-lite"
#IMAGE_FILE=/home/nfs/isos/vyatta-lite.img
ADMIN_TENANT="service"
FLAVOR_ID=10
source /root/keystone_rc



#create a new user and add it into the project
#keystone user-create --name ${USER_NAME} --pass ${USER_PWD} --tenant-id ${TENANT_ID} --email ${USER_EMAIL}
#USER_ID=`keystone user-list|grep ${USER_NAME}|awk '{print $2}'`
#ROLE_ID=`keystone role-list|grep ${USER_ROLE}|awk '{print $2}'`
#keystone user-role-add --tenant-id ${TENANT_ID}  --user-id ${USER_ID} --role-id ${ROLE_ID}

TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`

SUBNET_ID=`neutron subnet-list|grep ${INT_SUBNET_NAME}|awk '{print $2}'`
ROUTER_ID=`neutron router-list|grep ${ROUTER_NAME}|awk '{print $2}'`
EXT_NET_ID=`neutron net-list|grep ${EXT_NET_NAME}|awk '{print $2}'`

if [ -n "$ROUTER_ID" ]; then 
echo Removing the router added
neutron router-gateway-clear ${ROUTER_ID} ${EXT_NET_ID}
neutron router-interface-delete ${ROUTER_ID} ${SUBNET_ID}
neutron router-delete ${ROUTER_ID}
echo
fi


INT_NET_ID=`neutron net-list|grep ${INT_NET_NAME}|awk '{print $2}'`

if [ -n "$INT_NET_ID" ]; then
echo Removing the internal net added
neutron net-delete ${INT_NET_ID}
echo
fi


if [ -n "$EXT_NET_ID" ]; then
echo Removing the external net added
ADMIN_ID=`keystone tenant-list| grep ${ADMIN_TENANT} |awk '{print $2}'`
neutron net-delete ${EXT_NET_NAME} --router:external=True
#EXT_NET_VLAN_ID=`neutron net-show ${EXT_NET_NAME}|grep provider:segmentation_id | awk '{print $4}'`
#echo External_VLAN_ID= ${EXT_NET_VLAN_ID}
#neutron subnet-create --tenant-id ${ADMIN_ID} --name ${EXT_SUBNET_NAME} --allocation-pool start=${FLOAT_IP_START},end=${FLOAT_IP_END} --gateway ${EXT_GATEWAY} ${EXT_NET_NAME} ${EXT_IP_CIDR} --enable_dhcp=False
fi

if [ -n "$TENANT_ID" ]; then
	echo Removing the project added
	TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`
	keystone tenant-delete ${TENANT_ID}
echo
fi

nova image-list
IMAGE_ID=
IMAGE_ID=`nova image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
if [ -n "$IMAGE_ID" ]; then 
echo Removing the image added
    glance image-delete ${IMAGE_ID}
fi	

FLAVOR_NAME=
FLAVOR_NAME=`nova flavor-list| grep ${FLAVOR_ID}| awk '{print $4}'`
if [ -n "$FLAVOR_NAME" ]; then
echo Removing the flavor $FLAVOR_NAME
nova flavor-delete 10
fi


echo done!
echo neutron net-list
neutron net-list
echo neutron port-list
neutron port-list
echo neutron router-list
neutron router-list
echo nova list
nova list


#change to user and add security rules, then start a vm
#export OS_TENANT_NAME=${TENANT_NAME}
#export OS_USERNAME=${USER_NAME}
#export OS_PASSWORD=${USER_PWD}
#nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

#nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

#neutron floatingip-create ${EXT_NET_NAME}

#sed -i 's/#libvirt_inject_password=false/libvirt_inject_password=true/g' /etc/nova/nova.conf
#ssh root@${COMPUTE_IP} "sed -i 's/#libvirt_inject_password=false/libvirt_inject_password=true/g' /etc/nova/nova.conf; /etc/init.d/openstack-nova-compute restart"
exit


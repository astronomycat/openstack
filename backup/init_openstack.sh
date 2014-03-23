#!/bin/sh
#Create a project and add a new user with net/subnet/vm image...

#Those variables can be customized.
TENANT_NAME="vyatta"
TENANT_DESC="vyatta demo: VPN, FW"
USER_NAME="vyatta"
USER_PWD="303034"
USER_EMAIL="user@domain.com"
USER_ROLE="Member"
INT_NET_NAME="internal"
INT_SUBNET_NAME="subnet_int"
EXT_NET_NAME="external"
EXT_SUBNET_NAME="subnet_ext"
ROUTER_NAME="vRouter"
INT_IP_CIDR="192.168.100.0/24"
FLOAT_IP_START="9.186.105.242"
FLOAT_IP_END="9.186.105.250"
EXT_GATEWAY="9.186.105.1"
EXT_IP_CIDR="9.186.105.0/24"
IMAGE_NAME="vyatta-lite"
IMAGE_FILE=/home/nfs/isos/vyatta-lite-ss.img
VM_NAME="vyatta"
ADMIN_TENANT="service"
source /root/keystone_rc


echo
echo create a new project
keystone tenant-create --name ${TENANT_NAME} --description "${TENANT_DESC}"
TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`
echo

#create a new user and add it into the project
#keystone user-create --name ${USER_NAME} --pass ${USER_PWD} --tenant-id ${TENANT_ID} --email ${USER_EMAIL}
#USER_ID=`keystone user-list|grep ${USER_NAME}|awk '{print $2}'`
#ROLE_ID=`keystone role-list|grep ${USER_ROLE}|awk '{print $2}'`
#keystone user-role-add --tenant-id ${TENANT_ID}  --user-id ${USER_ID} --role-id ${ROLE_ID}

echo
echo create a new internal net and subnet
neutron net-create --tenant-id ${TENANT_ID} ${INT_NET_NAME}
neutron subnet-create --tenant-id ${TENANT_ID} --name ${INT_SUBNET_NAME} ${INT_NET_NAME} ${INT_IP_CIDR} --dns_nameservers list=true 8.8.8.7 8.8.8.8
echo

#echo create a router and add it to the subnet
#neutron router-create  ${ROUTER_NAME}
#SUBNET_ID=`neutron subnet-list|grep ${INT_SUBNET_NAME}|awk '{print $2}'`
#ROUTER_ID=`neutron router-list|grep ${ROUTER_NAME}|awk '{print $2}'`
#neutron router-interface-add ${ROUTER_ID} ${SUBNET_ID}

echo create a new external net and subnet
echo
ADMIN_ID=`keystone tenant-list| grep ${ADMIN_TENANT} |awk '{print $2}'`
neutron net-create --tenant-id ${ADMIN_ID} ${EXT_NET_NAME} --router:external=True
EXT_NET_VLAN_ID=`neutron net-show ${EXT_NET_NAME}|grep provider:segmentation_id | awk '{print $4}'`
echo External_VLAN_ID= ${EXT_NET_VLAN_ID}
neutron subnet-create --tenant-id ${ADMIN_ID} --name ${EXT_SUBNET_NAME} --allocation-pool start=${FLOAT_IP_START},end=${FLOAT_IP_END} --gateway ${EXT_GATEWAY} ${EXT_NET_NAME} ${EXT_IP_CIDR} --enable_dhcp=True
echo

#echo add routers external gateway
#EXT_NET_ID=`neutron net-list|grep ${EXT_NET_NAME}|awk '{print $2}'`
#neutron router-gateway-set ${ROUTER_ID} ${EXT_NET_ID}
#echo

IMAGE_ID=
IMAGE_ID=`nova image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
if [ -f ${IMAGE_ID} ]; then
    echo upload a vm image
    glance add disk_format=qcow2 container_format=ovf name=${IMAGE_NAME} is_public=true < ${IMAGE_FILE} 
    #IMAGE_ID=`nova image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
    glance image-list	
fi
echo

echo nova flavor-create --is-public true vyatta 10 512 1 1
nova flavor-create --is-public true vyatta 10 512 1 1
echo
echo

neutron port-list --all-tenant
neutron net-list --all-tenant
neutron router-list --all-tenant

nova list 
nova host-list 


echo done.
sh add-veth-pair.sh

#if in GRE, then open this to reduce the MTU to improve throughput
#if [ ! -f /etc/neutron/dnsmasq-neutron.conf ]; then
#    echo "dhcp-option-force=26,1454" >  /etc/neutron/dnsmasq-neutron.conf
#fi
#sed -i 's/# dnsmasq_config_file =/dnsmasq_config_file = /etc/neutron/dnsmasq-neutron.conf/g' /etc/neutron/dhcp_agent.ini
#service neutron-dhcp-agent restart

#change to user and add security rules, then start a vm

#nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
#nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

#neutron floatingip-create ${EXT_NET_NAME}

#sed -i 's/#libvirt_inject_password=false/libvirt_inject_password=true/g' /etc/nova/nova.conf
#ssh root@${COMPUTE_IP} "sed -i 's/#libvirt_inject_password=false/libvirt_inject_password=true/g' /etc/nova/nova.conf; /etc/init.d/openstack-nova-compute restart"
exit


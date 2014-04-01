INT_IF=eth0
EXT_NET_NAME="external"

source /root/keystone_rc
VLAN_ID=`neutron net-show ${EXT_NET_NAME}|grep provider:segmentation_id |awk '{print $4}'`
echo VLAN_ID=${VLAN_ID}


echo ip link delete ${EXT_NET_NAME}-INT
ip link delete ${EXT_NET_NAME}-INT 

echo ovs-vsctl del-port br-ex ${EXT_NET_NAME}-EXT
ovs-vsctl del-port br-ex ${EXT_NET_NAME}-EXT
echo ovs-vsctl del-port br-$INT_IF ${EXT_NET_NAME}-INT
ovs-vsctl del-port br-$INT_IF ${EXT_NET_NAME}-INT




echo ip link add name ${EXT_NET_NAME}-INT type veth peer name ${EXT_NET_NAME}-EXT
ip link add name ${EXT_NET_NAME}-INT type veth peer name ${EXT_NET_NAME}-EXT

ifconfig ${EXT_NET_NAME}-INT up
ifconfig ${EXT_NET_NAME}-EXT up

echo ovs-vsctl add-port br-ex ${EXT_NET_NAME}-EXT
ovs-vsctl add-port br-ex ${EXT_NET_NAME}-EXT
echo ovs-vsctl add-port br-$INT_IF ${EXT_NET_NAME}-INT tag=${VLAN_ID}
ovs-vsctl add-port br-$INT_IF ${EXT_NET_NAME}-INT tag=${VLAN_ID}

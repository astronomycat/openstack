ovs-vsctl del-port br-ex veth-ex-eth1
ovs-vsctl del-port br-eth1 veth-eth1-ex

EXT_NET_NAME="external"

source ./keystone_rc
VLAN_ID=`neutron net-show ${EXT_NET_NAME}|grep provider:segmentation_id |awk '{print $4}'`
echo VLAN_ID=${VLAN_ID}
ip link add name veth-eth1-ex type veth peer name veth-ex-eth1
ifconfig veth-eth1-ex up
ifconfig veth-ex-eth1 up
ovs-vsctl add-port br-ex veth-ex-eth1
ovs-vsctl add-port br-eth1 veth-eth1-ex tag=${VLAN_ID}

INT_PORT_IP="192.168.100.3"
EXT_PORT_IP="9.186.105.243"
NET_NAME1="internal"
NET_NAME2="external"

TAP_ID1=`neutron port-list | grep ${INT_PORT_IP} | awk '{print $2}' | cut -c 1-11`
#echo TAP_ID1=${TAP_ID1}
TAP_NAME1=tap${TAP_ID1}
echo INT_TAP_NAME=${TAP_NAME1}

TAP_ID2=`neutron port-list | grep ${EXT_PORT_IP} | awk '{print $2}' | cut -c 1-11`
TAP_NAME2=tap${TAP_ID2}
echo EXT_TAP_NAME=${TAP_NAME2}


EXT_VLAN_ID1=`neutron net-show ${NET_NAME1}|grep provider:segmentation_id | awk '{print $4}'`
echo INT_VLAN_ID.global=${EXT_VLAN_ID1}
INT_VLAN_ID1=`ovs-ofctl dump-flows br-int | grep dl_vlan=${EXT_VLAN_ID1}| awk '{for(i=1;i<100;i++) if($i~ /actions/) print $i}' | awk -F '[:,]' '{print $2}'`
#INT_VLAN_ID1=`ovs-ofctl dump-flows br-int | grep dl_vlan=${EXT_VLAN_ID1}| awk '{print $9}' | awk -F '[:,]' '{print $2}'`
echo INT_VLAN_ID.local=${INT_VLAN_ID1}

EXT_VLAN_ID2=`neutron net-show ${NET_NAME2}|grep provider:segmentation_id | awk '{print $4}'`
echo EXT_VLAN_ID.global=${EXT_VLAN_ID2}
INT_VLAN_ID2=`ovs-ofctl dump-flows br-int | grep dl_vlan=${EXT_VLAN_ID2}| awk '{for(i=1;i<100;i++) if($i~ /actions/) print $i}' | awk -F '[:,]' '{print $2}'`
#INT_VLAN_ID2=`ovs-ofctl dump-flows br-int | grep dl_vlan=${EXT_VLAN_ID2}| awk '{print $9}' | awk -F '[:,]' '{print $2}'`
echo EXT_VLAN_ID.local=${INT_VLAN_ID2}

if [ "$1" = "commit" ]; then
	echo ovs-vsctl del-port br-int ${TAP_NAME1}
	ovs-vsctl del-port br-int ${TAP_NAME1}
	echo ovs-vsctl del-port br-int ${TAP_NAME2}
	ovs-vsctl del-port br-int ${TAP_NAME2}

	echo ovs-vsctl add-port br-int ${TAP_NAME1} tag=${INT_VLAN_ID1}
	ovs-vsctl add-port br-int ${TAP_NAME1} tag=${INT_VLAN_ID1}
	echo ovs-vsctl add-port br-int ${TAP_NAME2} tag=${INT_VLAN_ID2}
	ovs-vsctl add-port br-int ${TAP_NAME2} tag=${INT_VLAN_ID2}
fi

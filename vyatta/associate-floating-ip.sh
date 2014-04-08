#!/bin/vbash

# Associate Floating IP addr to internal IP addr

# Kai Zheng: zhengkai@cn.ibm.com


source /root/openstack-scripts/header.sh
nat_entry_id=
floating_ip=
internal_ip=

while getopts "e:f:i:" arg
do
        case $arg in
             f)
                echo "floating_ip="$OPTARG
                floating_ip=$OPTARG
                ;;
             e)
                echo "nat_entry_id="$OPTARG
                nat_entry_id=$OPTARG
                ;;
	     i)
		echo "internal_ip="$OPTARG
		internal_ip=$OPTARG	
		;;
             ?)
            echo "unkonw argument"
            echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
	    exit 1
        ;;
        esac
done

if [ x${floating_ip} = x ] ; then
echo "Please provide floating ip addr"
echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
exit;
fi

if [ x${internal_ip} = x ] ; then
echo "Please provide internal ip addr"
echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
exit;
fi

if [ x${nat_entry_id} = x ] ; then
echo "Please provide nat entry id"
echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
exit;
fi




$SET nat source rule $nat_entry_id source address $internal_ip 
$SET nat source rule $nat_entry_id translation address $floating_ip 
$SET nat source rule $nat_entry_id outbound-interface eth0 

$SET nat destination rule $nat_entry_id destination address $floating_ip 
$SET nat destination rule $nat_entry_id translation address $internal_ip 
$SET nat destination rule $nat_entry_id inbound-interface eth0 

$COMMIT
$SAVE

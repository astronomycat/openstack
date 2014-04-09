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
            echo "unknown argument"
            echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
	    exit 1
        ;;
        esac
done

if [ x${floating_ip} = x ] ; then
echo "Please provide floating ip addr"
echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
exit 1;
fi

if [ x${internal_ip} = x ] ; then
echo "Please provide internal ip addr"
echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
exit 1;
fi

if [ x${nat_entry_id} = x ] ; then
echo "Please provide nat entry id"
echo "usage associate-floating-ip.sh <-e nat_entry_id> <-f floating_ip> <-i internal_ip>"
exit 1;
fi

test=`ip addr | grep ${floating_ip}| awk '{print $6}'`
if [ x$test = x ] ; then
echo "The specified floating IP has not been allocated."
exit 1;
fi


/bin/ping -c 1 $internal_ip > ping.txt 
sleep 1
test=`cat ping.txt | grep ttl | awk '{print $6}'`
rm ./ping.txt
if [ x$test = x ] ; then
echo "No route to internal host "$internal_ip
exit 1;
fi


dnat_entry_id=`/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=destination | grep $floating_ip | awk '{print $1}'`
#echo dnat_entry_id=$dnat_entry_id
snat_entry_id=`/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=source | grep $floating_ip | awk '{print $1}'`
#echo snat_entry_id=$snat_entry_id


if [[ x${snat_entry_id} != x ||  x${dnat_entry_id} != x ]] ; then
echo "Floating IP alreay associated."
exit 1;
fi

$SET nat source rule $nat_entry_id source address $internal_ip 
$SET nat source rule $nat_entry_id translation address $floating_ip 
$SET nat source rule $nat_entry_id outbound-interface eth0 

$SET nat destination rule $nat_entry_id destination address $floating_ip 
$SET nat destination rule $nat_entry_id translation address $internal_ip 
$SET nat destination rule $nat_entry_id inbound-interface eth0 



action=`arptables -nL --line-number | grep $floating_ip | awk '{print $3}'`

if [ x$action = xDROP ] ; then
echo "removing the ARP blocking rule..."
echo arptables -D INPUT -d $floating_ip -j DROP
arptables -D INPUT -d $floating_ip -j DROP
fi

$COMMIT
$SAVE

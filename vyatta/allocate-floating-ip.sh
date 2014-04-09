#!/bin/vbash

# Allocate a floating IP to the vRouter

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh
floating_ip=
vrrp_group_id=`/opt/vyatta/bin/sudo-users/vyatta-show-vrrp.pl --show=summary | grep eth0 | awk '{print $2}'`

if [ x${vrrp_group_id} = x ] ; then
vrrp_group_id=100
fi

block_arp=

echo "warning: the default vrrp-group is set to "$vrrp_group_id

while getopts "f:g:a" arg 
do
        case $arg in
             f)
               	echo "floating_ip="$OPTARG
		floating_ip=$OPTARG
		floating_ip_addr=`echo $floating_ip | awk -F/ '{print $1 }' `
		#echo $floating_ip_addr
                ;;
             g)
                echo "vrrp-groud-id="$OPTARG
		vrrp_group_id=$OPTARG
                ;;
	     a)
		echo "block arp on the allocating floating IP"
		block_arp=y
		;;	
             ?)  
            	echo "unknown argument"
   	    	echo "usage allocate-floating-ip.sh <-f floating_ip/subnet_len> [-a ] [-g vrrp_group_id]"		
        	exit 1
        	;;
        esac
done

if [ x${floating_ip} = x ] ; then
echo "usage allocate-floating-ip.sh <-f floating_ip/subnet_len> [-a ][-g vrrp_group_id]"
exit;
fi

test=`echo ${floating_ip} | grep /`
if [ x$test = x ] ;  then
echo "usage allocate-floating-ip.sh <-f floating_ip/subnet_len> [-a ][-g vrrp_group_id]"
echo "you must specify the subnet len."
exit 1
fi


 
$SET interfaces ethernet eth0 vrrp vrrp-group $vrrp_group_id virtual-address $floating_ip 

if [ x$block_arp = xy ] ;  then
echo "adding the ARP blocking rule..."
echo arptables -A INPUT -d $floating_ip_addr -j DROP
arptables -A INPUT -d $floating_ip_addr -j DROP
fi

$COMMIT 
$SAVE


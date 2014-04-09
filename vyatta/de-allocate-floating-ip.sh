#!/bin/vbash

# Release a floating IP from the vRouter

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh


floating_ip=
vrrp_group_id=`/opt/vyatta/bin/sudo-users/vyatta-show-vrrp.pl --show=summary | grep eth0 | awk '{print $2}'`
echo "warning: the default vrrp-group is set to "$vrrp_group_id

while getopts "f:g:" arg
do
        case $arg in
             f)
                echo "floating_ip="$OPTARG
                floating_ip=$OPTARG
                ;;
             g)
                echo "vrrp-groud-id="$OPTARG
                vrrp_group_id=$OPTARG
                ;;
             ?)
            echo "unkonw argument"
            echo "usage allocate-floating-ip.sh <-f floating_ip/subnet_len> [-g vrrp_group_id]"
        exit 1
        ;;
        esac
done

if [ x${floating_ip} = x ] ; then
echo "usage allocate-floating-ip.sh <-f floating_ip/subnet_len> [-g vrrp_group_id]"
exit;
fi

test=`echo ${floating_ip} | grep /`
if [ x$test = x ] ;  then
echo "usage allocate-floating-ip.sh <-f floating_ip/subnet_len> [-g vrrp_group_id]"
echo "you must specify the subnet len."
exit
fi


echo delete interfaces ethernet eth0 vrrp vrrp-group $vrrp_group_id virtual-address $floating_ip
$DELETE interfaces ethernet eth0 vrrp vrrp-group $vrrp_group_id virtual-address $floating_ip
$COMMIT
$SAVE

exit

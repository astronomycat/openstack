#!/bin/vbash

# Release a floating IP from the vRouter

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh


floating_ip=
vrrp_group_id=100

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
            echo "usage allocate-floating-ip.sh <-f floating_ip> [-g vrrp_group_id]"
        exit 1
        ;;
        esac
done

if [ x${floating_ip} = x ] ; then
echo "usage allocate-floating-ip.sh <-f floating_ip> [-g vrrp_group_id]"
exit;
fi




$DELETE interfaces ethernet eth0 vrrp vrrp-group $vrrp_group_id virtual-address $floating_ip
$COMMIT
$SAVE

exit

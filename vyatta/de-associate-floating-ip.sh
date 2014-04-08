#!/bin/vbash

# De-associate Floating IP addr to internal IP addr

# Kai Zheng: zhengkai@cn.ibm.com


source /root/openstack-scripts/header.sh
nat_entry_id=
floating_ip=

while getopts "f:" arg
do
        case $arg in
             f)
                echo "floating_ip="$OPTARG
                floating_ip=$OPTARG
                ;;
             ?)
            echo "unkonw argument"
            echo "usage associate-floating-ip.sh <-f floating_ip>"
	    exit 1
        ;;
        esac
done

if [ x${floating_ip} = x ] ; then
echo "usage associate-floating-ip.sh <-f floating_ip>"
exit;
fi

dnat_entry_id=`/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=destination | grep $floating_ip | awk '{print $1}'`
echo dnat_entry_id=$dnat_entry_id
snat_entry_id=`/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=source | grep $floating_ip | awk '{print $1}'`
echo snat_entry_id=$snat_entry_id

if [ $dnat_entry_id != $snat_entry_id ] ; then
echo "DNAT and SNAT id entries unmatched"
exit
fi

if [ x${snat_entry_id} = x ] ; then
echo "Can not find matched floating ip..."
exit;
fi


echo delete nat source rule $snat_entry_id
$DELETE nat source rule $snat_entry_id  

echo delete nat destination rule $dnat_entry_id
$DELETE nat destination rule $dnat_entry_id 

$COMMIT
$SAVE

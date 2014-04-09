#!/bin/vbash

# Delete NAT rule 

# Kai Zheng: zhengkai@cn.ibm.com


source /root/openstack-scripts/header.sh
nat_entry_id=
dst=
src=
dst_or_src=

while getopts "dsn:" arg
do
        case $arg in
             n)
                echo "nat_entry_id="$OPTARG
                nat_entry_id=$OPTARG
                ;;
             d)
		echo "will remove DNAT"
		dst=y
		dst_or_src=y
		;;
             s)
                echo "will remove SNAT"
                src=y
		dst_or_src=y
                ;;

		
	     ?)	
            	echo "unknow argument"
            	echo "usage del-nat-rule.sh <-n nat_entry_id> <-d/-s>"
	    	exit 1
        	;;
        esac
done

if [ x${nat_entry_id} = x ] ; then
echo "usage del-nat-rule.sh <-n nat_entry_id> <-d/-s>"
exit 1;
fi


if [ x${dst_or_src} = x ] ; then
echo "usage del-nat-rule.sh <-n nat_entry_id> <-d/-s>"
exit 1;
fi


if [ x${dst} != x ] ; then
	echo "delete nat destination rule "$nat_entry_id
        $DELETE nat destination rule $nat_entry_id

fi


if [ x${src} != x ] ; then
	echo "delete nat source rule "$nat_entry_id
        $DELETE nat source rule $nat_entry_id
fi


$COMMIT
$SAVE

#!/bin/vbash

# Show and save nat configure dumps

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh

dump_to_file=

while getopts "d" arg 
do
        case $arg in
             d)
               	echo "will dump to file show_nat_rules_(dst/src).txt"$OPTARG
		dump_to_file=y
                ;;
             ?)  
            	echo "unkonw argument"
   	    	echo "usage show-firewall.sh [-d]"		
        	exit 1
        	;;
        esac
done

if [ x${dump_to_file} != x ] ; then
	/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=destination  > /root/show_nat_rules_dst.txt
	/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=source > /root/show_nat_rules_src.txt
else
	/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=destination
	/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=source
fi

 


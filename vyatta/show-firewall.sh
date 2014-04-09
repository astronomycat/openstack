#!/bin/vbash

# Show and save firewall configure dumps

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh

dump_to_file=

while getopts "d" arg 
do
        case $arg in
             d)
               	echo "will dump to file show_firewall.txt"$OPTARG
		dump_to_file=y
                ;;
             ?)  
            	echo "unknown argument"
   	    	echo "usage show-firewall.sh [-d]"		
        	exit 1
        	;;
        esac
done

if [ x${dump_to_file} != x ] ; then
	/opt/vyatta/bin/vyatta-show-firewall.pl "firewall_all" /opt/vyatta/share/xsl/show_firewall_detail.xsl > /root/show_firewall.txt
else
	/opt/vyatta/bin/vyatta-show-firewall.pl "firewall_all" /opt/vyatta/share/xsl/show_firewall_detail.xsl

fi

 


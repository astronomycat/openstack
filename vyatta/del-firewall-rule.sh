#!/bin/vbash

# Delete firewall rule/policy

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh

#action=accept
#echo "warning: the default action is set to "$action
#policy_name=to-private
policy_name=to-public  	#in most cases, we want to set this
echo "warning: the default policy_name is set to "$policy_name

rule_number=
#source_ip_range=0.0.0.0/0
#destination_ip_range=0.0.0.0/0
#source_port=
#destination_port=
#protocol=tcp		#can be udp,tcp,icmp

while getopts "n:r:" arg 
do
        case $arg in
             n)
                echo "policy_name="$OPTARG
                policy_name=$OPTARG
                ;;
             r)
                echo "rule_number="$OPTARG
                rule_number=$OPTARG
                ;;
             ?)  
            	echo "unkonw argument"
   	    	echo "usage set-firewall-rule.sh <-r rule_number> [-n policy_name]"		
        	exit 1
        	;;
        esac
done

if [ x${rule_number} = x ] ; then
echo "usage set-firewall-rule.sh <-r rule_number> [-n policy_name]"
exit;
fi



$DELETE firewall name $policy_name rule $rule_number

$COMMIT 
$SAVE


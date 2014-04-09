#!/bin/vbash

# Set firewall rule/policy

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh

action=accept
echo "warning: the default action is set to "$action
#policy_name=to-private
policy_name=to-public  	#in most cases, we want to set this
echo "warning: the default policy_name is set to "$policy_name

rule_number=
source_ip_range=0.0.0.0/0
destination_ip_range=0.0.0.0/0
source_port=
destination_port=
protocol=tcp		#can be udp,tcp,icmp

while getopts "a:n:s:d:p:i:l:r:" arg 
do
        case $arg in
             a)
                echo "action="$OPTARG
                action=$OPTARG
                ;;
             n)
                echo "policy_name="$OPTARG
                policy_name=$OPTARG
                ;;
             s)
                echo "source_port="$OPTARG
                source_port=$OPTARG
                ;;
             d)
                echo "destination_port="$OPTARG
                destination_port=$OPTARG
                ;;
             p)
                echo "protocol="$OPTARG
                protocol=$OPTARG
                ;;
             i)
               	echo "source_ip_range="$OPTARG
		source_ip_range=$OPTARG
                ;;
             l)
                echo "destination_ip_range="$OPTARG
		destination_ip_range=$OPTARG
                ;;
             r)
                echo "rule_number="$OPTARG
                rule_number=$OPTARG
                ;;
             ?)  
            	echo "unkonw argument"
		echo "usage set-firewall-rule.sh <-r rule_number> [-n policy_name]"
		echo "                           [-a action][-i src_ip][-l dst_ip]"
		echo "                           [-s src_ports][-d dst_ports]"
		echo "                           [-p protocols]"
        	exit 1
        	;;
        esac
done

if [ x${rule_number} = x ] ; then
echo "usage set-firewall-rule.sh <-r rule_number> [-n policy_name]"
echo "                           [-a action][-i src_ip][-l dst_ip]"
echo "                           [-s src_ports][-d dst_ports]"
echo "                           [-p protocols]"
exit;
fi



$SET firewall name $policy_name rule $rule_number
$SET firewall name $policy_name rule $rule_number action $action

if [ x${dst_port} != x ] ; then
$SET firewall name $policy_name rule $rule_number destination port $dst_port
fi

if [ x${src_port} != x ] ; then
$SET firewall name $policy_name rule $rule_number source port $src_port
fi

if [ x${protocol} != x ] ; then
$SET firewall name $policy_name rule $rule_number protocol $protocol
fi

if [ x${dst_ip} != x ] ; then
$SET firewall name $policy_name rule $rule_number destination address $dst_ip
fi

if [ x${src_ip} != x ] ; then
$SET firewall name $policy_name rule $rule_number source address $src_ip
fi
$COMMIT 
$SAVE


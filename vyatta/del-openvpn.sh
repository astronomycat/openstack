#!/bin/vbash

# Remove openvpn server

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh

#tls_key_path=/config/auth/keys/
#echo "warning: the default tls_key_path is set to "$tls_key_path

#vtun_name=vtun0
#echo "warning: the default vtun name is set to "$vtun_name

#mode=server
#echo "warning: the default mode of vtun0 is set to "$mode

#server_subnet=
#server_push_route=


#openvpn_option=--comp-lzo
#echo "warning: the default openvpn-option name is set to "$openvpn-option

#protocol=tcp-passive
#echo "warning: the default protocol is set to "$protocol



while getopts "n:" arg 
do
        case $arg in
             n)
                echo "vtun_name="$OPTARG
                vtun_name=$OPTARG
                ;;
	     ?)
            	echo "unkonw argument"
		echo "usage set-openvpn <-n vtun_name>"
        	exit 1
        	;;
        esac
done

if [ x${vtun_name} = x ] ; then
                echo "usage set-openvpn <-n vtun_name>"

exit;
fi

$DELETE interfaces openvpn $vtun_name


$COMMIT 
$SAVE

